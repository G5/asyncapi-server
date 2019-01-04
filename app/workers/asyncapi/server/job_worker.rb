module Asyncapi::Server
  class JobWorker

    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_options retry: false
    MAX_RETRIES = 2

    sidekiq_throttle({
      # If throttled, set the concurrency to `concurrency` along with user defined job.parameter key
      :concurrency => {
        :limit      => ->(throttled) { (!!throttled) ? throttled["concurrency"].to_i : 10 },
        :key_suffix => ->(job_id, throttled) { (!!throttled) ? fetch_key(job_id, throttled) : job_id }
      }
    })

    def perform(job_id, retries=0, throttled)
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
        # For some reason "ActiveRecord::Base.after_transaction",
        # ":after_commit" and ":after_create" does not prevent
        # the ActiveRecord-Sidekiq race condition. In order to
        # prevent this just retry running JobWorker until it finds
        # the job by job_id.
        if retries <= MAX_RETRIES
          JobWorker.perform_async(job_id, retries+1)
        end
      end
    end

    private

    def fetch_key(job_id, throttled)
      job = Job.find(job_id)
      job.params.dig(*throttled["keys"]).to_s
    end

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
