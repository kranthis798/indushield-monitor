class CreateCompanyAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :company_agreements do |t|
      t.string :title
      t.string :description
      t.string :url
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
