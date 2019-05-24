class Api::KioskController < Api::ApiController
	before_action :authenticate

	def get_company_info
		record = Company.find params[:sugar_id]
	    status = record.nil? ? 404 : 200
	    record = confirm_mod_date(record, params[:modified_after])
	    resp =  status == 200 ?  {company: record.try(:kiosk_payload), status:status } :
	            {error:"Cannot find record by ID #{sugar_id}", status:status }
	    render json: resp, status: status
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def get_device_info
	    serial = params[:serial]
	    record = Device.includes(:building).find_by_identifier(serial)
	    status = record.nil? ? 404 : 200
	    record = confirm_mod_date(record, params[:modified_after])
		resp = status == 200 ?  {device:record.try(:kiosk_payload), status:status } :
            	{error:"Cannot find device by serial #{serial}", status:status }
	    render json: resp, status: status
	rescue => e
  		render json: {message: e.message}, status: 500
	end
	
  	def verify_phone
  		phone_num =  params.require(:phone_mobile).gsub(/-/,'')
  		otp = rand.to_s[2..7]
  		#device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
  	 	msg = "Your One-time PIN is: #{otp}"
	  	Rails.application.config.twilio_client.send_sms(msg, phone_num)
	  	render json: {otp: otp, message:"Verification code sent"}, status: :ok
  	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def get_vendor_companies
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
		device_info = Device.find(device_id)
		company_info = Company.find(device_info.company_id)
		render json: {vendor_companies: company_info.vendor_agencies}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def register_visitor
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	    payload = params[:registrant].is_a?(String) ? JSON.parse(params[:registrant]) : params[:registrant]
	    # Validate input
	    errors = RegisterVisitorValidator.validate(payload, params[:type])
	    if errors.length > 0
	      hash_response = {visitor: nil, type: nil, msg: errors.join(" | ")}
	      render json: hash_response, status: 400
	    end
	    msg, us_state_id, comp_id = get_company_us_state_device(device_id)
	    if us_state_id.present?
	    	is_guest = (params[:type].try(:downcase) == "visitor")
	    	registrant_type = params[:type]
	    	find_visitor payload['phone_mobile'], us_state_id, is_guest

	    	if @visitor.nil?
		        logger.info "Can't find registrant in this US State. OK to continue with new registration"
		        @visitor = do_register(registrant_type, us_state_id, payload, comp_id)
		    else
		        logger.info "WARNING! Found existing registrant. Not creating a new one"
		    end
		    render json: {visitor:@visitor.try(:kiosk_payload), type:registrant_type}, status: 200
		else
	    	render json: {message: "ERROR! You must pass a valid device_id in the header. You passed #{device_id}"}, status: 400
	    end
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def signin
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	    msg, us_state_id, comp_id = get_company_us_state_device(device_id)
	    if us_state_id.present?
	    	registrant_type = params[:type]
	    	register_class = registrant_type == "vendor" ? Vendor : Guest
	    	@visitor = register_class.signin(params[:phone_mobile], params[:pin_c], us_state_id)
	    	if @visitor.present?
	    		render json: {visitor:@visitor.try(:kiosk_payload), type:registrant_type}, status: 200
	    	else
	    		render json: {message: "ERROR! Invaid Phone number / PIN"}, status: 400
	    	end
	    else
	    	render json: {message: "ERROR! You must pass a valid device_id in the header. You passed #{device_id}"}, status: 400
	    end
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def set_personal_details
		payload = params[:registrant].is_a?(String) ? JSON.parse(params[:registrant]) : params[:registrant]
	    registrant_type = params[:type]
    	register_class = registrant_type == "vendor" ? Vendor : Guest
    	@visitor = register_class.update_register(payload)
    	render json: {visitor:@visitor.try(:kiosk_payload), type:registrant_type}, status: 200
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def reset_pin
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	    payload = params[:registrant].is_a?(String) ? JSON.parse(params[:registrant]) : params[:registrant]
	    errors = Validators::RegisterVisitorValidator.validate(payload, params[:type])
	    if errors.length > 0
	      hash_response = {visitor: nil, type: nil, msg: errors.join(" | ")}
	      render json: hash_response, status: 400
	    end
	    msg, us_state_id, comp_id = get_company_us_state_device(device_id)
	    if us_state_id.present?
	    	is_guest = (params[:type].try(:downcase) == "visitor")
	    	registrant_type = params[:type]
	    	find_visitor payload['phone_mobile'], us_state_id, is_guest
	    	if @visitor.present?
	    		register_class = registrant_type == "vendor" ? Vendor : Guest
	    		@visitor.update! pin:payload.pin_c
	    		render json: {visitor:@visitor.try(:kiosk_payload), type:registrant_type}, status: 200
	    	else
	    		render json: {message: "ERROR! Invaid Phone number"}, status: 400
	    	end
	    else
	    	render json: {message: "ERROR! You must pass a valid device_id in the header. You passed #{device_id}"}, status: 400
	    end
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def get_departments
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
		device_info = Device.find(device_id)
		departments = Department.where(company_id:device_info.company_id)
		render json: {departments:departments}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	
		
	def get_company_agreements
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
		device_info = Device.find(device_id)
		agreements = CompanyAgreement.where(company_id:device_info.company_id)
		render json: {agreements: agreements}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def accept_agreements
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
		device_info = Device.find(device_id)
		agreements = CompanyAgreement.where(company_id:device_info.company_id)
		@vendor = Vendor.find(params[:vendor_id])
		agreements.each do|agreement|
			@vendor.company_agreements << agreement
		end
		render json: {message: "Success"}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def process_events
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	    payload = params[:entries].is_a?(String) ? JSON.parse(params[:entries]) : params[:entries]
	    visitor_type = payload['visitor_type'] == "VENDOR" ? :Vendor : :Guest
	    visit_entry_type = payload['visit_entry_type'] == "SIGNIN" ? :Visit : :Signout
	    time_millis = (Time.now.to_f * 1000).to_i
	    qrcode_id = SecureRandom.uuid+"-"+time_millis.to_s
	    @visit = Visit.create! visitor_type:visitor_type,visit_entry_type:visit_entry_type,visitor_id:payload['visitor_id'],person_name:payload['person_name'],on_date: on_date_str(payload['event_time']),on_date_time:payload['event_time'],start_time:event_time_hhmm(payload['event_time']),device_id:device_id, company_id:payload['company_id'],department_id:payload['department_id'],visit_status: :current, event_id:payload['event_id'],qrcode_id:qrcode_id,triggered_by: 'Kiosk'
		render json: {visit:@visit.try(:kiosk_payload)}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def process_qr_events
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	    payload = params[:entries].is_a?(String) ? JSON.parse(params[:entries]) : params[:entries]
	    if payload['visit_id']
	    	@visit = Visit.find(payload['visit_id'])
	    	@visit.update! on_date: on_date_str(payload['event_time']),on_date_time:payload['event_time'],start_time:event_time_hhmm(payload['event_time']),device_id:device_id,visit_status: :current, event_id:payload['event_id']
	    	render json: {visit:@visit.try(:kiosk_payload)}, status: :ok
	    else
	    	render json: {message: "Missing Visit id"}, status: not_found
	    end

	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def validate_QR
		@visit = Visit.find_by_qrcode_id(params[:qrcode])
		if @visit.present?
			render json: {visit:@visit.try(:kiosk_payload)}, status: :ok
		else
	    	render json: {message: "ERROR! Invalid QR Code"}, status: 400
	    end
	rescue => e
  		render json: {message: e.message}, status: 500
	end
		
	def signout
		@visit = Visit.find_by_qrcode_id(params[:qrcode])
		if @visit.present?
			@visit.update! end_time:event_time_hhmm(params[:event_time]), end_date_time:params[:event_time]
			render json: {visit:@visit.try(:kiosk_payload)}, status: :ok
		else
	    	render json: {message: "ERROR! Invalid QR Code"}, status: 400
	    end

	rescue => e
  		render json: {message: e.message}, status: 500
	end	

		
	private

	def confirm_mod_date(record, modified_after)
	    if record
	      if modified_after
	        must_be_modded_after = DateTime.parse modified_after
	        return record.updated_at >= must_be_modded_after ? record : nil
	      else
	        record
	      end
	    end
 	end

	def get_company_us_state_device(device_id)
		d = Device.find device_id
	    if d && d.company
	      us_state_id = d.company.us_state_id
	      comp_id = d.company.id
	    else
	      msg = "v2: register_visitor() We were unable to find either device or a linked community to device id #{device_id}"
	      p msg
	    end
	    return msg, us_state_id, comp_id
	end

	def get_us_state_id(device_id)
    	if device_id.present?
	      p "v2: get_us_state_id() No State ID passed, attempting to find by device sugar id #{device_id}"
	      state = Device.find(device_id).try(:building).try(:company).try(:us_state_id)
	      if state.present?
	        state
	      else
	        nil
	      end
	    else
	      nil
	    end
  	end

  	def on_date_datetime
	    @on_date_dt ||= DateTime.parse event_time
	end

	  def event_epoch
	    on_date_datetime.to_i * 1000
	  end

	  def event_time_hhmm(event_time)
	    @eve_time = DateTime.parse event_time
	    @eve_time.strftime("%-l:%M %p").strip
	  end

	  def on_date_str(event_time)
	    @eve_time = DateTime.parse event_time
	    @eve_time.strftime "%Y-%m-%d"
	  end

  	def do_register(registrant_type, us_state_id, registrant_payload, company_id, skip_welcome_sms=false)
	    registrant_payload['status'] = "temporary"
	    register_class = registrant_type == "vendor" ? Vendor : Guest
	    register_class.register(registrant_payload, us_state_id, company_id)
	end

	def find_visitor(phone, state_id, is_type, search_both_types=false)
    logger.info "find_visitor() Looking for visitor by phone #{phone}. First trying type: #{is_type} at US State ID #{state_id}"
    if state_id.present?
      is_type = is_type === true ? "guest" : is_type === false ? "vendor" : is_type
      if is_type == "guest"
        @type = :guest
        @visitor = find_guest(phone, state_id)
        if @visitor.nil? && search_both_types
          @visitor = find_vendor(phone, state_id)
          @type = :vendor
        end
      else
        @type = :vendor
        @visitor = find_vendor(phone, state_id)
        if @visitor.nil? && search_both_types
          @visitor = find_guest(phone, state_id)
          @type = :guest
        end
      end
      if @visitor.nil?
         @type = nil
      end
    else
      msg = "ERROR! No State ID available. phone: #{phone}, is_type #{is_type}"
    end
  end

  def find_guest(phone, state_id)
    Guest.find_by_phone_num_and_us_state_id(phone, state_id)
  end

  def find_vendor(phone, state_id)
    Vendor.find_by_phone_num_and_us_state_id(phone, state_id)
  end

end