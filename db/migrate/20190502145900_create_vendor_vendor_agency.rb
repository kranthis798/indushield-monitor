class CreateVendorVendorAgency < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_vendor_agencies do |t|
      t.references :vendor_agency, foreign_key: true
      t.references :vendor, foreign_key: true
    end
  end
end
