class AddUserIdToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :user_id, :integer
  end
end
