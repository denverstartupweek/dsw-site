class AddReportFieldsToZoomEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :zoom_events, :report_fetched_at, :datetime
    add_column :zoom_events, :duration, :integer
    add_column :zoom_events, :total_minutes, :integer
    add_column :zoom_events, :participants_count, :integer
    add_column :zoom_events, :actual_start_time, :string
    add_column :zoom_events, :actual_end_time, :string
  end
end
