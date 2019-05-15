class VendorAgency < ApplicationRecord
  belongs_to :us_state
  has_and_belongs_to_many :companies, :join_table => :company_vendor_agencies
end
