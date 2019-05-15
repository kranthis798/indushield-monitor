class AddDateSignedToCompanyAgreementVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :company_agreements_vendors, :date_signed, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
