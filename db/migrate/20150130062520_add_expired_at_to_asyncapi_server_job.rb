class AddExpiredAtToAsyncapiServerJob < ActiveRecord::Migration[4.2]
  def change
    add_column :asyncapi_server_jobs, :expired_at, :datetime

    Asyncapi::Server::Job.reset_column_information

    Asyncapi::Server::Job.
      where(Asyncapi::Server::Job.arel_table[:expired_at].eq(nil)).
      update_all(expired_at: Asyncapi::Server.expiry_threshold.from_now)
  end
end
