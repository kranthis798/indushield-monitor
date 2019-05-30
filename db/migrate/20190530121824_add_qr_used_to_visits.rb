class AddQrUsedToVisits < ActiveRecord::Migration[5.2]
  def change
  	add_column :visits, :qr_used, :integer, default: 0
  end
end
