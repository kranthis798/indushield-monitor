class AddGuestTypeToGuests < ActiveRecord::Migration[5.2]
  def change
  	add_column :guests, :guest_type, :integer
  end
end
