class AddEndDateTimeToVisits < ActiveRecord::Migration[5.2]
  def change
  	add_column :visits, :end_date_time, :datetime
  	remove_column :visits, :triggered_by
  	add_column :visits, :triggered_by, :string
  	add_column :visits, :triggered_by_os, :string
  end
end
