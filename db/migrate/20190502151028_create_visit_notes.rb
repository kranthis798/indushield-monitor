class CreateVisitNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_notes do |t|
      t.belongs_to :visit, foreign_key: true
      t.string :before_visit
      t.string :after_visit

      t.timestamps
    end
  end
end
