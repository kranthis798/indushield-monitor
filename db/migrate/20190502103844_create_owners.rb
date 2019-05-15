class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :phone
      t.belongs_to :us_state, foreign_key: true

      t.timestamps
    end
  end
end
