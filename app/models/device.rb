class Device < ApplicationRecord
  belongs_to :building
  belongs_to :company

  enum status: [:active, :inactive]
  enum device_mode: [:production, :qa, :dev, :demo]
  enum debug_mode: [:off, :terse, :verbose]
  enum identifier_type: [:serial, :hardware_mac_address, :imei, :custom_generated, :wifi_mac_address, :other]
  enum printer_type: [:ql_710, :ql_800, :ql_820]
  enum printer_connection: [:wifi, :usb, :bluetooth]
  enum printer_status: [:enabled, :disabled, :printer_no]
  after_create :set_default_status

  def set_default_status
    update_attribute :status, :active if status.nil?
  end
  
   def kiosk_payload
    payload = {id:id, name:name,
    			company_id:company_id,
               #restart_time_c: restart_time,
               #session_timeout_c: idle_timeout_secs,
               #debug_mode_c: debug_mode,
               device_mode_c: device_mode,
               status_c: status,
               printer_status_c: printer_status,
               printer_conn_c: printer_connection,
               #printer_ip_c:printer_ip,
               #placement_c: placement,
               #lava_c: lava_version,
               # badge_visitors_c: bool_to_int(do_badge_visitors),
               # is_bypass_build_c: bool_to_int(is_bypass_build),
               # do_external_logs_c: bool_to_int(do_external_logs),
               # do_force_resplinter_c: bool_to_int(do_force_resplinter),
               date_entered: created_at,
               date_modified: updated_at,
               identifier: identifier,
               identifier_type: identifier_type,
               #update_int_secs: update_int_secs,
               #session_max_hrs: session_max_hrs
               }
    if building
      payload[:building_id] = building_id
      payload[:building_name] = building.name
    else
      msg = "ERROR! device.kiosk_payload() Cannot find building for device #{id}"
      p msg
     end
    payload
  end
end
