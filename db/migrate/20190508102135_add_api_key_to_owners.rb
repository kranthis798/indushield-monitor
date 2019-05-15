class AddApiKeyToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :api_key, :string
  end
end
