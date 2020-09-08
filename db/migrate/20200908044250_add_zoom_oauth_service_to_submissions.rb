class AddZoomOauthServiceToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_reference :submissions, :zoom_oauth_service, foreign_key: {to_table: :oauth_services}
    add_reference :zoom_events, :oauth_service, foreign_key: true, null: false
  end
end
