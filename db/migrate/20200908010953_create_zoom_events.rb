class CreateZoomEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :zoom_events do |t|
      t.references :submission, foreign_key: true
      t.string :zoom_id, null: false
      t.string :event_type, null: false
      t.string :kind, null: false
      t.timestamps
    end
  end
end
