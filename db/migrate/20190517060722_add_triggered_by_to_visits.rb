class AddTriggeredByToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :triggered_by, :integer
  end
end
