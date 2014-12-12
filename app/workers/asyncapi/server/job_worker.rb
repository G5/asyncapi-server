module Asyncapi::Server
  class JobWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(job_id)
      job = Job.find(job_id)
      runner_class = job.class_name.constantize

      job_status = :success
      job_message = runner_class.call(job.params)
    rescue => e
      job_status = :error
      job_message = [e.message, e.backtrace].flatten.join("\n")
    ensure
      job.update_attributes(status: job_status)
      report_job_status(job, job_message)
    end

    private

    def report_job_status(job, job_message)
      Typhoeus.put(
        job.callback_url,
        body: {
          job: {
            status: job.status,
            message: job_message,
            secret: job.secret,
          }
        }.to_json,
        headers: {
          "Content-Type" => "application/json",
          Accept: "application/json"
        }
      )
    end

  end
end
