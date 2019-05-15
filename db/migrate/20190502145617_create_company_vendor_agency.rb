class CreateCompanyVendorAgency < ActiveRecord::Migration[5.2]
  def change
    create_table :company_vendor_agencies do |t|
      t.references :vendor_agency, foreign_key: true
      t.references :company, foreign_key: true
    end
  end
end
