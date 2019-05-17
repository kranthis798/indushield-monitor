class AddVisitEntryTypeToVisits < ActiveRecord::Migration[5.2]
  def change
  	add_column :visits, :visit_entry_type, :integer
  	add_column :visits, :event_id, :string
  	add_column :visits, :qrcode_id, :string
  end
end
