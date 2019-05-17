class Company < ApplicationRecord
  belongs_to :us_state
  belongs_to :owner
  has_many :devices
  has_many :buildings, :dependent => :destroy
  has_and_belongs_to_many :vendor_agencies, :join_table => :company_vendor_agencies
  enum status: [:active, :inactive]

   has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
   validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]

  after_create :set_default_status

  def set_default_status
    update_attribute :status, :active if status.nil?
  end

  def kiosk_payload
    avatar_url=''
    if avatar.exists? 
      avatar_url = avatar.url
      {id: id, name: name, date_entered: created_at, date_modified: updated_at,
       kiosk_count: devices.count, owner_id: owner.try(:id), us_state_id: us_state_id, status_c: status, avatar_url: avatar_url}
    else
      {id: id, name: name, date_entered: created_at, date_modified: updated_at,
       kiosk_count: devices.count, owner_id: owner.try(:id), us_state_id: us_state_id, status_c: status}
    end
  end

  def serializable_hash options=nil
    if type.present?
      super.merge "type" => type
    else
      super
    end
  end

end
