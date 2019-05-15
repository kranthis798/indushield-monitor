class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :identifier
      t.string :identifier_type
      t.string :device_mode
      t.string :model_number
      t.string :description
      t.string :printer_type
      t.string :printer_connection
      t.string :printer_status
      t.string :restart_time
      t.belongs_to :building, foreign_key: true
      t.belongs_to :company, foreign_key: true
      t.datetime :last_sync_at
      t.integer :status

      t.timestamps
    end
  end
end
