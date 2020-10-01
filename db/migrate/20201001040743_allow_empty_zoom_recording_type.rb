class AllowEmptyZoomRecordingType < ActiveRecord::Migration[6.0]
  def change
    change_column_null :zoom_recordings, :zoom_recording_type, true
  end
end
