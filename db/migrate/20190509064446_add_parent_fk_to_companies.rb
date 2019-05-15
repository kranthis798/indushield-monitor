class AddParentFkToCompanies < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :parent_id, :string
  end
end
