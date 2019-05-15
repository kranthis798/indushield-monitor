class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_num
      t.integer :pin
      t.integer :status
      t.belongs_to :us_state, foreign_key: true

      t.timestamps
    end
  end
end
