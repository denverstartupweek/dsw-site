class ChangeTypeOnZoomEventReportingDates < ActiveRecord::Migration[6.0]
  def change
    remove_column :zoom_events, :actual_start_time, :string
    add_column :zoom_events, :actual_start_time, :datetime
    remove_column :zoom_events, :actual_end_time, :string
    add_column :zoom_events, :actual_end_time, :datetime
  end
end
