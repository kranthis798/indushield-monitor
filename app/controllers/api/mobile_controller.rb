class Api::MobileController < Api::ApiController
	require 'uri'
	before_action :authorize_request, :except => [:signin, :forgot_pin, :reset_pin]
	attr_reader :current_visitor, :visitor_type
	

	def get_visitor_companies
		register_class = visitor_type == "vendor" ? Vendor : Guest
		@visitor = register_class.find(current_visitor.id)
		@customers = []
		@visitor.companies.each do|company|
			@customers << company.try(:kiosk_payload)
		end
		render json: {customers: @customers}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def forgot_pin
  		phone_num =  params.require(:phone_mobile).gsub(/-/,'')
  		find_visitor phone_num, true, true
  		if @visitor.nil?
  			render json: {message: "Invalid phone number"}, status: :not_found
  		else
	  		otp = rand.to_s[2..7]
	  		#device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
	  	 	msg = "Your One-time PIN is: #{otp}"
		  	Rails.application.config.twilio_client.send_sms(msg, phone_num)
		  	render json: {otp: otp, message:"Verification code sent"}, status: :ok
		end
  	rescue => e
  		render json: {message: e.message}, status: 500
	end


	def signin
		registrant_type = params[:type].try(:downcase)
	    register_class = registrant_type == "vendor" ? Vendor : Guest
    	@visitor = register_class.signin_mobile(params[:phone_mobile], params[:pin_c])
    	if @visitor.present?
    		auth_token = JsonWebToken.encode(visitor_id: @visitor.id.to_s,type:registrant_type)
    		render json: {visitor:@visitor.try(:kiosk_payload), vendor_company:@visitor.vendor_agencies, type:registrant_type, auth_token:auth_token}, status: 200
    	else
    		render json: {message: "ERROR! Invaid Phone number / PIN"}, status: 400
    	end
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def get_visits
		visitor_class = visitor_type == "vendor" ? :Vendor : :Guest
		@visits = Visit.where(visitor_type:visitor_class,visitor_id:current_visitor.id,company_id:params['company_id'])
		@processed_visits = []
		@visits.each do|visit|
			@processed_visits << visit.try(:kiosk_payload)
		end
		render json: {visits:@processed_visits}, status: 200
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def get_agreements
		com_agreements = current_visitor.company_agreements.where(company_id: params['company_id']) 
		render json: {agreements:com_agreements}, status: 200
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def set_personal_details
		payload = params[:registrant].is_a?(String) ? JSON.parse(params[:registrant]) : params[:registrant]
	    registrant_type = visitor_type
    	register_class = registrant_type == "vendor" ? Vendor : Guest
    	payload['visitor_id'] = current_visitor.id
    	@visitor = register_class.update_register(payload)
    	render json: {visitor:@visitor.try(:kiosk_payload), vendor_company:@visitor.vendor_agencies, type:registrant_type}, status: 200
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def reset_pin
		is_guest = (params[:type].try(:downcase) == "visitor")
    	find_visitor params[:phone_mobile], true, true
    	if @visitor.present?
    		@visitor.update! pin:params[:pin_c]
    		render json: {message:"Pin updated successfully"}, status: 200
    	else
    		render json: {message: "ERROR! Invaid Phone number"}, status: 400
    	end
	rescue => e
  		render json: {message: e.message}, status: 500
	end		

	def get_departments
		departments = Department.where(company_id:params[:company_id])
		render json: {departments:departments}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	
		
	def process_events
		payload = params[:entries].is_a?(String) ? JSON.parse(params[:entries]) : params[:entries]
		ivisitor_type = visitor_type == "vendor" ? :Vendor : :Guest
		visit_entry_type = :Visit
	    time_millis = (Time.now.to_f * 1000).to_i
	    qrcode_id = SecureRandom.uuid+"-"+time_millis.to_s
	    @visit = Visit.create! visitor_type:ivisitor_type,visit_entry_type:visit_entry_type,visitor_id:current_visitor.id,person_name:payload['person_name'],tentative_datetime: payload['tentative_datetime'],company_id:payload['company_id'],department_id:payload['department_id'],visit_status: :pre_visit, qrcode_id:qrcode_id,triggered_by: 'Mobile', send_message: params[:send_message], person_contact: params[:person_contact],triggered_by_os: params[:triggered_by_os],device_id:1
		msg = "#{visitor_type} will be visiting on #{payload['tentative_datetime']} "
		if params[:visit_notes]
			msg = params[:visit_notes]
			VisitNote.create! visit_id:@visit.id, before_visit:params[:visit_notes]
		end
		if params[:send_message]
			if payload['person_contact'].match(URI::MailTo::EMAIL_REGEXP).present?
				NotifierMailer.visit_alert(msg, payload['person_contact'].to_s).deliver_now
			else
				Rails.application.config.twilio_client.send_sms(msg, payload['person_contact'])
			end
		end
		render json: {visit:@visit.try(:kiosk_payload)}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def get_notes
		visit_notes = VisitNote.where(visit_id:params[:visit_id])
		render json: {notes:visit_notes}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def update_notes
		notes = VisitNote.find(params[:notes_id])
		notes.update! before_visit: params[:before_visit], after_visit: params[:after_visit]
		render json: {visit_notes:notes}, status: :ok
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

  	def do_register(registrant_type, us_state_id, registrant_payload, company_id, skip_welcome_sms=false)
	    registrant_payload['status'] = "temporary"
	    register_class = registrant_type == "vendor" ? Vendor : Guest
	    register_class.register(registrant_payload, us_state_id, company_id)
	end

	def find_visitor(phone, is_type, search_both_types=false)
      is_type = is_type === true ? "guest" : is_type === false ? "vendor" : is_type
      if is_type == "guest"
        @type = :guest
        @visitor = find_guest(phone)
        if @visitor.nil? && search_both_types
          @visitor = find_vendor(phone)
          @type = :vendor
        end
      else
        @type = :vendor
        @visitor = find_vendor(phone)
        if @visitor.nil? && search_both_types
          @visitor = find_guest(phone)
          @type = :guest
        end
      end
      if @visitor.nil?
         @type = nil
      end
  	end

  def find_guest(phone)
    Guest.find_by_phone_num(phone)
  end

  def find_vendor(phone)
    Vendor.find_by_phone_num(phone)
  end

end