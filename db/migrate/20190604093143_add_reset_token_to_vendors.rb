class AddResetTokenToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :reset_token, :integer
  end
end
