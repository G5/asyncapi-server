class CreateAsyncapiServerJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :asyncapi_server_jobs do |t|
      t.integer :status
      t.string :callback_url
      t.string :class_name
      t.text :params
    end
  end
end
