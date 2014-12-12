# This migration comes from asyncapi_server (originally 20141212064931)
class AddSecretToAsyncapiServerJob < ActiveRecord::Migration
  def change
    add_column :asyncapi_server_jobs, :secret, :string
  end
end
