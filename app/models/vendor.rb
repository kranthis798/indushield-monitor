class Vendor < ApplicationRecord
	has_and_belongs_to_many :vendor_agencies, :join_table => :vendor_vendor_agencies
	has_and_belongs_to_many :company_agreements, :join_table => :company_agreements_vendors
	has_and_belongs_to_many :companies, :join_table => :vendor_companies
	belongs_to :us_state
	enum status: [:active, :inactive, :temporary, :denied]
	enum vendor_type: [:independent, :agency]

	def self.register(registrant_payload, us_state_id, company_id)
	    payload = OpenStruct.new registrant_payload
		# record = create! first_name:payload.first_name, last_name:payload.last_name, phone_num:payload.phone_mobile,status:payload.status_c,
	 	#                     pin:payload.vendor_pin_c, us_state_id:us_state_id
	 	record = create! phone_num:payload.phone_mobile, pin:payload.vendor_pin_c, phone_verified: true, us_state_id:us_state_id, status:payload.status
	    #Link to Company
	    ext = record.companies.where(id:company_id)
		if ext.present?
			p "already mapped"
		else
   		  record.companies << Company.find(company_id)
		end
	    record
	end
	def self.update_register(registrant_payload)
	    payload = OpenStruct.new registrant_payload
	    @vendor = Vendor.find(payload.visitor_id)
		@vendor.update! first_name:payload.first_name, last_name:payload.last_name, email:payload.email, vendor_type: payload.vendor_type
		#Link to Vendor Agency
		if payload.vendor_company_id.present?
			ext = @vendor.vendor_agencies.where(id:payload.vendor_company_id)
			if ext.present?
				p "already mapped"
			else
				@vendor.vendor_agencies << VendorAgency.find(payload.vendor_company_id)
			end
	  	end
	  	@vendor
	end

	def self.signin(phone_mobile, pin_c, us_state_id)
		@vendor = Vendor.find_by_phone_num_and_pin_and_us_state_id(phone_mobile, pin_c, us_state_id)
		@vendor
	end

	def self.signin_mobile(phone_mobile, pin_c)
	    @guest = Vendor.find_by_phone_num_and_pin(phone_mobile, pin_c)
	    @guest
	end  

	def self.kiosk_fields
	    %w(id first_name last_name email phone_num updated_at status pin vendor_type)
	end

	def kiosk_payload
	    serializable_hash.select do |k,v|; Vendor.kiosk_fields.include?(k); end
	end
end
