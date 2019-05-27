class Visit < ApplicationRecord
  belongs_to :device
  belongs_to :company
  belongs_to :department
  #belongs_to :service_type

  enum visitor_type: [:Vendor, :Guest]
  enum visit_entry_type: [:Visit, :Signout]
  enum visit_status: [:pre_visit, :current]

  def kiosk_payload
  	visitor_class = visitor_type == "Vendor" ? Vendor : Guest
    payload = {id:id, visitor_type:visitor_type,
    			visitor_id:visitor_id, department_id:department_id,department_name:department.name,
    			visit_status:visit_status,person_name:person_name,event_id:event_id,qrcode:qrcode_id,
    			send_message: send_message, person_contact:person_contact,tentative_datetime:tentative_datetime,
    			start_date_time:on_date_time,end_date_time:end_date_time,
    			date_entered: created_at,date_modified: updated_at
               }
    
    payload
  end

end
