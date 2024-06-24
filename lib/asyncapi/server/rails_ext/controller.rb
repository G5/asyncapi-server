module Asyncapi
  module Server
    module RailsExt
      module Controller
        extend ActiveSupport::Concern

        module ClassMethods
          
          def async(method_name, klass)
            define_method(method_name) do
              job = Job.create(job_params_with(klass.name))
              JobWorker.perform_async(job.id)
              serializer = JobSerializer.new(job)
              render json: serializer
            end
          end
        end

        def job_params_with(class_name)
          params[:job].merge!(class_name: class_name)
          params.require(:job).permit(
            :callback_url,
            :class_name,
            :params,
            :secret,
          )
        end

      end
    end
  end
end
