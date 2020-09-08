class CreateYoutubeLiveStreams < ActiveRecord::Migration[6.0]
  def change
    create_table :youtube_live_streams do |t|
      t.references :submission, null: false, foreign_key: true
      t.text :name
      t.string :live_stream_id
      t.string :broadcast_id
      t.text :ingestion_address
      t.text :backup_ingestion_address
      t.text :rtmps_ingestion_address
      t.text :rtmps_backup_ingestion_address
      t.text :stream_name
      t.timestamps
    end
  end
end
