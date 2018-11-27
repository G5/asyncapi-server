class DropExpiredAtFromAsyncapiServerJobs < ActiveRecord::Migration[4.2]
  def up
    remove_column :asyncapi_server_jobs, :expired_at
  end

  def down
    add_column :asyncapi_server_jobs, :expired_at, :datetime
  end
end
