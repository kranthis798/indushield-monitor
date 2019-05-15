class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :visitor_type
      t.integer :visitor_id
      t.string :person_name
      t.date :on_date
      t.time :tentative_time
      t.belongs_to :device, foreign_key: true
      t.belongs_to :company, foreign_key: true
      t.belongs_to :department, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.string :purpose
      t.belongs_to :service_type, foreign_key: true
      t.integer :visit_status

      t.timestamps
    end
  end
end
