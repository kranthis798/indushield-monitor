class ChangeTentativeTimeInVisits < ActiveRecord::Migration[5.2]
  def change
  	remove_column :visits, :tentative_time
  	add_column :visits, :tentative_datetime, :datetime
  	add_column :visits, :on_date_time, :datetime
  end
end
