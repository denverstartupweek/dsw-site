class AddKindToYoutubeLiveStreams < ActiveRecord::Migration[6.0]
  def change
    add_column :youtube_live_streams, :kind, :string, null: false
    remove_column :youtube_live_streams, :name, :string
  end
end
