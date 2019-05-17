class RemoveAvatarFromVisits < ActiveRecord::Migration[5.2]
  def change
  	remove_attachment :visits, :avatar
  end
end
