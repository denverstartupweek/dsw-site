class FetchZoomRecordingsJob
  include Sidekiq::Worker

  def perform(zoom_event_id)
    ZoomEvent.find(zoom_event_id).fetch_recordings!
  end
end
