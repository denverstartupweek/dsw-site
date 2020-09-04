class AddZoomMeetingTypeToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :virtual_meeting_type, :string
  end
end
