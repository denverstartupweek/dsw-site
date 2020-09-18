class CreateZoomRecordings < ActiveRecord::Migration[6.0]
  def change
    create_table :zoom_recordings do |t|
      t.references :zoom_event, foreign_key: true, null: false
      t.string :zoom_recording_id, null: false
      t.string :zoom_file_type, null: false
      t.string :zoom_play_url, null: false
      t.string :zoom_recording_type, null: false
      t.string :file, null: false

      t.timestamps
    end
    add_index :zoom_recordings, [:zoom_event_id, :zoom_file_type, :zoom_recording_type], unique: true, name: "idx_zoom_recordings_on_types"
  end
end
