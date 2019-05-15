class CreateUsStates < ActiveRecord::Migration[5.2]
  def change
    create_table :us_states do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
