class AddExpiredAtToAsyncapiServerJobs < ActiveRecord::Migration
  def change
    add_column :asyncapi_server_jobs, :expired_at, :datetime
  end
end
