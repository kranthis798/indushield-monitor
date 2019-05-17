class Api::MobileController < Api::ApiController
	
	def get_vendor_companies
		device_id = request.headers["device_id"] || request.headers["HTTP_DEVICE_ID"]
		device_info = Device.find(device_id)
		company_info = Company.find(device_info.company_id)
		render json: {vendor_companies: company_info.vendor_agencies}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end	

	def get_visitor_companies
		register_class = params[:type] == "vendor" ? Vendor : Guest
		@visitor = register_class.find(params['visitor_id'])
		@customers = []
		@visitor.companies.each do|company|
			@customers << company.try(:kiosk_payload)
		end
		render json: {customers: @customers}, status: :ok
	rescue => e
  		render json: {message: e.message}, status: 500
	end

	def signin
		registrant_type = params[:type]
	    register_class = registrant_type == "vendor" ? Vendor : Guest
    	@visitor = register_class.signin_mobile(params[:phone_mobile], params[:pin_c])
    	if @visitor.present?
    		render json: {visitor:@visitor.try(:kiosk_payload), type:registrant_type}, status: 200
    	else
    		render json: {message: "ERROR! Invaid Phone number / PIN"}, status: 400
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
	    time_millis = (Time.now.to_f * 1000).to_i
	    qrcode_id = SecureRandom.uuid+"-"+time_millis.to_s
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