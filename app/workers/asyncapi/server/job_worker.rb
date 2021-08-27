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
        job.update(status: job_status)
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

    def report_job_status(job, job_message)
      JobStatusNotifierWorker.perform_async(job.id, job_message)
    end
  end
end
