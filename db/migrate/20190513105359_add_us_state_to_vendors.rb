class AddUsStateToVendors < ActiveRecord::Migration[5.2]
  def change
  	change_table :vendors do |t|
	  	t.belongs_to :us_state, foreign_key: true
	end
  end
end
