module Asyncapi::Server
  class JobStatusNotifierWorker

    include Sidekiq::Worker
    sidekiq_options retry: false
    MAX_RETRIES = 2

    def perform(job_id, job_message, retries=0)
      @job = Job.find(job_id)

      report_job_status(job_message)

      unless @response.code == 200
        if retries <= MAX_RETRIES
          @jid = JobStatusNotifierWorker.perform_async(job_id, job_message, retries+1)
        else
          raise format_error("Something went wrong while poking #{@job.callback_url}")
        end
      end
    end

    private

    def report_job_status(job_message)
      @response ||= Typhoeus.put(
        @job.callback_url,
        timeout: 60,
        connecttimeout: 60,
        body: {
          job: {
            status: @job.status,
            message: @job_message,
            secret: @job.secret,
          }
        }.to_json,
        headers: {
          "Content-Type" => "application/json",
          Accept: "application/json"
        }
      )
    end

    def format_error(error)
      [
        error,
        "JobID: #{@job.id}",
        "Next Attempt: #{@jid}",
        "HTTP Status: #{@response.code}",
        "HTTP Response: #{@response.inspect}",
      ].join("\n")
    end
  end
end
