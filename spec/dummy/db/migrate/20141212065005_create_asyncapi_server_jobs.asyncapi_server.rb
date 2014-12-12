# This migration comes from asyncapi_server (originally 20141112034324)
class CreateAsyncapiServerJobs < ActiveRecord::Migration
  def change
    create_table :asyncapi_server_jobs do |t|
      t.integer :status
      t.string :callback_url
      t.string :class_name
      t.text :params
    end
  end
end
