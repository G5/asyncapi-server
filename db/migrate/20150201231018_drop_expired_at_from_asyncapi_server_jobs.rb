class DropExpiredAtFromAsyncapiServerJobs < ActiveRecord::Migration
  def up
    remove_column :asyncapi_server_jobs, :expired_at
  end

  def down
    add_column :asyncapi_server_jobs, :expired_at, :datetime
  end
end
