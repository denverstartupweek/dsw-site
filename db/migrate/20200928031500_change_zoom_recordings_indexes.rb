class ChangeZoomRecordingsIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :zoom_recordings, name: "idx_zoom_recordings_on_types"
    add_index :zoom_recordings, [:zoom_recording_id], unique: true
  end
end
