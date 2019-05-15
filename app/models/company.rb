class Company < ApplicationRecord
  belongs_to :us_state
  belongs_to :owner
  has_many :devices
  has_many :buildings, :dependent => :destroy
  has_and_belongs_to_many :vendor_agencies, :join_table => :company_vendor_agencies
  enum status: [:active, :inactive]

  after_create :set_default_status

  def set_default_status
    update_attribute :status, :active if status.nil?
  end

  def kiosk_payload
    {id: id, name: name, date_entered: created_at, date_modified: updated_at,
     kiosk_count: devices.count, owner_id: owner.try(:id), us_state_id: us_state_id, status_c: status}
  end

  def serializable_hash options=nil
    if type.present?
      super.merge "type" => type
    else
      super
    end
  end

end
