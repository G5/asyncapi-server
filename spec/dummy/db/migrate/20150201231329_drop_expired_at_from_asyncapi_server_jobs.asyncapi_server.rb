# This migration comes from asyncapi_server (originally 20150201231018)
class DropExpiredAtFromAsyncapiServerJobs < ActiveRecord::Migration
  def up
    remove_column :asyncapi_server_jobs, :expired_at
  end

  def down
    add_column :asyncapi_server_jobs, :expired_at, :datetime
  end
end
