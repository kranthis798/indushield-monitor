class AddResetTokenToGuests < ActiveRecord::Migration[5.2]
  def change
    add_column :guests, :reset_token, :integer
  end
end
