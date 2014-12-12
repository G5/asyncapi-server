class AddSecretToAsyncapiServerJob < ActiveRecord::Migration
  def change
    add_column :asyncapi_server_jobs, :secret, :string
  end
end
