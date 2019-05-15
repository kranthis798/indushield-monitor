class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :email
      t.string :phone_num
      t.belongs_to :company, foreign_key: true
      t.belongs_to :department, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
