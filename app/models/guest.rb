class Guest < ApplicationRecord
  belongs_to :us_state
  has_and_belongs_to_many :companies, :join_table => :guest_companies
  enum guest_type: [:visitor, :family, :friend]
  enum status: [:active, :inactive, :temporary, :denied]

  def self.register(registrant_payload, us_state_id, company_id)
    payload = OpenStruct.new registrant_payload
    # record = create! first_name:payload.first_name, last_name:payload.last_name, phone_num:payload.phone_mobile,status:payload.status_c,
    #                  pin:payload.pin_c, us_state_id:us_state_id, guest_type:payload.visitor_type_c
    record = create! phone_num:payload.phone_mobile, first_name:payload.first_name, last_name:payload.last_name, status:payload.status, pin:payload.pin_c, us_state_id:us_state_id, guest_type:payload.visitor_type_c
    #Link to Company
    record.companies << Company.find(company_id)
    record
  end

  def self.signin(phone_mobile, pin_c, us_state_id)
    @guest = Guest.find_by_phone_num_and_pin_and_us_state_id(phone_mobile, pin_c, us_state_id)
    @guest
  end

  def self.signin_mobile(phone_mobile, pin_c)
    @guest = Guest.find_by_phone_num_and_pin(phone_mobile, pin_c)
    @guest
  end  

  def self.kiosk_fields
    %w(id first_name last_name phone_num updated_at status)
  end

  def kiosk_payload
    serializable_hash.select do |k,v|; Guest.kiosk_fields.include?(k); end
  end


end
