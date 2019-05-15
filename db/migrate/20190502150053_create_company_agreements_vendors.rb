class CreateCompanyAgreementsVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :company_agreements_vendors do |t|
      t.references :vendor, foreign_key: true
      t.references :company_agreement, foreign_key: true
    end
  end
end
