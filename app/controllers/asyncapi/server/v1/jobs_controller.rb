module Asyncapi
  module Server
    module V1
      class JobsController < ApplicationController # TODO: Asyncapi::Server.parent_controller

        respond_to :json

        def index
          jobs = Job.all
          paginate json: jobs
        end

        def show
          job = Job.find(params[:id])
          respond_with job
        end

      end
    end
  end
end
