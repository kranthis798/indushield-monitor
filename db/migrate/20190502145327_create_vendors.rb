class CreateVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :vendors do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_num
      t.integer :pin
      t.boolean :phone_verified
      t.integer :status

      t.timestamps
    end
  end
end
