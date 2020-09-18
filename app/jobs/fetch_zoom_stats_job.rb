class FetchZoomStatsJob
  include Sidekiq::Worker

  def perform
    ZoomEvent.find_each do |ze|
      ze.fetch_reporting_data! if ze.report_fetched_at.blank?
    rescue Zoom::Error => e
      Rails.logger.info e.inspect
    end
  end
end
