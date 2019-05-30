class Guest < ApplicationRecord
  belongs_to :us_state
  has_and_belongs_to_many :companies, :join_table => :guest_companies
  enum guest_type: [:visitor, :family, :friend]
  enum status: [:active, :inactive, :temporary, :denied]

  def self.register(registrant_payload, us_state_id, company_id)
    payload = OpenStruct.new registrant_payload
    record = create! phone_num:payload.phone_mobile, status:payload.status, pin:payload.vendor_pin_c, us_state_id:us_state_id
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
      @guest = Guest.find(payload.visitor_id)
      @guest.update! first_name:payload.first_name, last_name:payload.last_name
      @guest
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
      %w(id first_name last_name phone_num updated_at status pin)
  end

  def kiosk_payload
      serializable_hash.select do |k,v|; Guest.kiosk_fields.include?(k); end
  end


end
