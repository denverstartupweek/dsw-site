class RefreshZoomUrlsJob
  include Sidekiq::Worker

  def perform
    ZoomEvent.find_each do |ze|
      ze.refresh_urls! unless ze.submission.start_datetime.past?
    end
  end
end
