class AddQueueItemIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :queue_item_id, :integer
  end
end
