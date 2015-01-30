# This migration comes from asyncapi_server (originally 20150130062520)
class AddExpiredAtToAsyncapiServerJob < ActiveRecord::Migration
  def change
    add_column :asyncapi_server_jobs, :expired_at, :datetime

    Asyncapi::Server::Job.reset_column_information

    Asyncapi::Server::Job.
      where(Asyncapi::Server::Job.arel_table[:expired_at].eq(nil)).
      update_all(expired_at: Asyncapi::Server.expiry_threshold)
  end
end
