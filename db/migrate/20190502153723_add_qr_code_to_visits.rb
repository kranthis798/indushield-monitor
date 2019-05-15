class AddQrCodeToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :qr_code, :binary, :limit => 10.megabyte
  end
end
