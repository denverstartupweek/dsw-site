class ZoomSubmissionSyncer
  def initialize(submission)
    @submission = submission
  end

  def run!
    return unless @submission.zoom_oauth_service.present?

    # TODO: handle removing streams when this is toggled off
    return unless @submission.is_virtual? && %w[zoom zoom_webinar].include?(@submission.virtual_meeting_type)

    Rails.logger.info "Creating events..."
    # create_test_event(@submission) unless test_event_exists?(@submission)
    create_live_event(@submission) unless live_event_exists?(@submission)
  end

  private

  def create_test_event(submission)
    Rails.logger.info "Creating test event..."
    zoom_event = submission.zoom_events.build(
      oauth_service: submission.zoom_oauth_service,
      event_type: submission.virtual_meeting_type,
      kind: ZoomEvent::TEST_KIND
    )
    zoom_event.create_on_zoom!
    if submission.broadcast_on_youtube_live? && submission.virtual_meeting_type == Submission::ZOOM_MEETING_TYPE
      stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::TEST_KIND).first!
      submission.zoom_oauth_service.zoom_client.livestream(
        meeting_id: zoom_event.zoom_id,
        stream_url: stream.ingestion_address,
        stream_key: stream.stream_name
        # page_url:
      )
    end
  end

  def create_live_event(submission)
    Rails.logger.info "Creating live event..."

    zoom_event = submission.zoom_events.build(
      oauth_service: submission.zoom_oauth_service,
      event_type: submission.virtual_meeting_type,
      kind: ZoomEvent::LIVE_KIND
    )
    zoom_event.create_on_zoom!
    if submission.broadcast_on_youtube_live? && submission.virtual_meeting_type == Submission::ZOOM_MEETING_TYPE
      stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).first!
      submission.zoom_oauth_service.zoom_client.livestream(
        meeting_id: zoom_event.zoom_id,
        stream_url: stream.ingestion_address,
        stream_key: stream.stream_name
        # page_url:
      )
    end
  end

  def test_event_exists?(submission)
    submission.zoom_events.where(kind: ZoomEvent::TEST_KIND).any?
  end

  def live_event_exists?(submission)
    submission.zoom_events.where(kind: ZoomEvent::LIVE_KIND).any?
  end
end
