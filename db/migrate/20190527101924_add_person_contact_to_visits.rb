class AddPersonContactToVisits < ActiveRecord::Migration[5.2]
  def change
  	add_column :visits, :send_message, :boolean
  	add_column :visits, :person_contact, :string
  end
end
