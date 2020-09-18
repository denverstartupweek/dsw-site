class RefreshZoomEventsJob
  include Sidekiq::Worker

  def perform
    ZoomEvent.find_each do |ze|
      ze.refresh_urls! unless ze.submission.start_datetime.past?
      # ze.fetch_reporting_data! if ze.report_fetched_at.blank?
    end
  end
end
