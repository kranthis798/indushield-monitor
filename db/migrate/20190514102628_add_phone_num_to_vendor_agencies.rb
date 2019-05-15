class AddPhoneNumToVendorAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :vendor_agencies, :phone_num, :string
    add_column :vendor_agencies, :email, :string
  end
end
