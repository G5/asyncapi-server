module Asyncapi::Server
  class JobWorker

    include Sidekiq::Worker
    sidekiq_options retry: false
    MAX_RETRIES = 2

    def perform(job_id, retries=0)
      job = Job.find(job_id)
      runner_class = job.class_name.constantize

      job_status = :success
      job_message = runner_class.call(job.params)
    rescue => e
      job_status = :error
      job_message = [e.message, e.backtrace].flatten.join("\n")
      raise e
    ensure
      if job
        job.update_attributes(status: job_status)
        report_job_status(job, job_message)
      else
        if retries < MAX_RETRIES
          JobWorker.perform_async(job_id, retries+1)
        end
      end
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
