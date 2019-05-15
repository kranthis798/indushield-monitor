class CreateVendorCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_companies do |t|
      t.references :company, foreign_key: true
      t.references :vendor, foreign_key: true
    end
  end
end
