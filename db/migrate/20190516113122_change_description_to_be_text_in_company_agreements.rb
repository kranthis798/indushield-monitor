class ChangeDescriptionToBeTextInCompanyAgreements < ActiveRecord::Migration[5.2]
  def change
  	change_column :company_agreements, :description, :text
  end
end
