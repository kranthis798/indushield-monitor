class CreateVendorAgencies < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_agencies do |t|
      t.string :name
      t.string :code
      t.string :business_type
      t.string :address1
      t.string :address2
      t.string :city
      t.belongs_to :us_state, foreign_key: true
      t.integer :zip
      t.integer :parent_id
      t.integer :status

      t.timestamps
    end
  end
end
