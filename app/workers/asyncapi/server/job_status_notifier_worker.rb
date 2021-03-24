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
          JobStatusNotifierWorker.perform_async(job_id, job_message, retries+1)

          raise format_error("Attempt##{retries} to notify #{@job.callback_url} failed.")
        else
          raise format_error("Something went wrong while poking #{@job.callback_url}")
        end
      end
    end

    private

    def report_job_status(job_message)
      @response ||= Typhoeus.put(
        @job.callback_url,
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
        "HTTP Status: #{@response.code}",
        "HTTP Body: #{@response.body}",
      ].join("\n")
    end
  end
end
