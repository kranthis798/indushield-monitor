class ChangeIdentifierTypeToBeIntegerInDevices < ActiveRecord::Migration[5.2]
  def change
  	Device.update_all(identifier_type: 0, device_mode:0, printer_type:0, printer_connection:0, printer_status:0)
  	change_column :devices, :identifier_type, 'integer USING CAST(identifier_type AS integer)'
  	change_column :devices, :device_mode, 'integer USING CAST(device_mode AS integer)'
  	change_column :devices, :printer_type, 'integer USING CAST(printer_type AS integer)'
  	change_column :devices, :printer_connection, 'integer USING CAST(printer_connection AS integer)'
  	change_column :devices, :printer_status, 'integer USING CAST(printer_status AS integer)'
  end
end
