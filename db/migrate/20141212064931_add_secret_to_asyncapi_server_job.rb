class AddSecretToAsyncapiServerJob < ActiveRecord::Migration[4.2]
  def change
    add_column :asyncapi_server_jobs, :secret, :string
  end
end
