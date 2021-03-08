module Asyncapi
  module Server
    module RailsExt
      module Controller
        extend ActiveSupport::Concern
        # require_relative "../../../../app/controllers/concerns/active_model_serializers_fix.rb"
        # include ::Controllers::Concerns::ActiveModelSerializersFix
        module ClassMethods
          
          # require_relative "../../../../app/controllers/concerns/active_model_serializers_fix.rb"
          
          # def namespace_for_serializer
          #   @namespace_for_serializer ||=
          #     if Module.method_defined?(:parent)
          #       self.class.parent unless self.class.parent == Object
          #     else
          #       self.class.module_parent unless self.class.module_parent == Object
          #     end
          # end
          
          def async(method_name, klass)
            define_method(method_name) do
              job = Job.create(job_params_with(klass.name))
              ActiveRecord::Base.after_transaction do
                JobWorker.perform_async(job.id)
              end
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
