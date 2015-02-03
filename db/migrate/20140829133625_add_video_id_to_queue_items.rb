class AddVideoIdToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :video_id, :integer
  end
end
