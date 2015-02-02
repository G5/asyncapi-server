module Asyncapi
  module Server
    module V1
      class JobsController < ApplicationController # TODO: Asyncapi::Server.parent_controller

        protect_from_forgery with: :null_session
        respond_to :json

        def index
          jobs = paginate Job.all
          serializer = ActiveModel::ArraySerializer.new(jobs)
          render json: serializer
        end

        def show
          job = Job.find(params[:id])
          job = JobSerializer.new(job)
          render json: job
        end

        def destroy
          job = Job.find_by(id: params[:id], secret: params[:secret])
          if job
            job.destroy
            respond_with job
          else
            render nothing: true, status: 404
          end
        end

      end
    end
  end
end
