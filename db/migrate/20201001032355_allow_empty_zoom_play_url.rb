class AllowEmptyZoomPlayUrl < ActiveRecord::Migration[6.0]
  def change
    change_column_null :zoom_recordings, :zoom_play_url, true
  end
end
