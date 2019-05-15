class AddAttachmentAvatarToVisits < ActiveRecord::Migration[5.2]
  def self.up
    change_table :visits do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :visits, :avatar
  end
end
