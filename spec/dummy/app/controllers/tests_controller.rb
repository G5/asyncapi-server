class TestsController < ApplicationController
  include ActiveModelSerializersFix

  async :create, Runner

end
