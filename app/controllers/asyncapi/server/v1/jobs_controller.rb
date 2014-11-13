module Asyncapi
  module Server
    module V1
      class JobsController < ApplicationController # TODO: Asyncapi::Server.parent_controller

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

      end
    end
  end
end
