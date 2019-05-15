class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :code
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :zip
      t.integer :parent_id
      t.belongs_to :us_state, foreign_key: true
      t.belongs_to :owner, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
