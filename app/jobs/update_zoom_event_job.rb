class UpdateZoomEventJob
  include Sidekiq::Worker

  def perform(zoom_event_id)
    ZoomEvent.find(zoom_event_id).update_on_zoom!
  end
end
