require "google/apis/youtube_v3"
require "google/api_client/client_secrets"

class ZoomSubmissionSyncer
  DEFAULT_MEETING_SETTINGS = {
    host_video: false,
    participant_video: false,
    join_before_host: false,
    mute_upon_entry: true,
    use_pmi: false,
    approval_type: 2,
    audio: "both",
    auto_recording: "cloud",
    waiting_room: true,
    meeting_authentication: false,
    registrants_email_notification: false
  }

  DEFAULT_WEBINAR_SETTINGS = {
    host_video: false,
    panelists_video: false,
    hd_video: true,
    approval_type: 2,
    audio: "both",
    auto_recording: "cloud",
    allow_multiple_devices: true,
    registrants_email_notification: false,
    meeting_authentication: false
  }

  def initialize(submission)
    @submission = submission
  end

  def run!
    return unless @submission.zoom_oauth_service.present?

    # TODO: Handle switching Oauth Services

    Rails.logger.info "Checking service to see if a token refresh is needed..."
    @submission.zoom_oauth_service.refresh_if_needed!

    # TODO: handle removing streams when this is toggled off
    return unless @submission.is_virtual? && %w[zoom zoom_webinar].include?(@submission.virtual_meeting_type)

    if @submission.zoom_events.any?
      # Update title/description, or adjust type if needed
    else
      Rails.logger.info "Creating events..."
      create_test_event(@submission) unless test_event_exists?(@submission)
      create_live_event(@submission) unless live_event_exists?(@submission)
    end
  end

  # Public for test stubbing
  def zoom_client
    @_zoom_client ||= Zoom::Client::OAuth.new(access_token: @submission.zoom_oauth_service.token, timeout: 15)
  end

  private

  def title_for(submission, suffix = nil)
    title = "DSW #{submission.year}: #{submission.title}"
    suffix_with_separator = if suffix
      " - #{suffix}"
    else
      ""
    end
    title.truncate(128 - suffix_with_separator.length) + suffix_with_separator
  end

  def description_for(submission)
    <<~DESC.strip.truncate(10000)
      Register and view the full schedule of events at denverstartupweek.org/schedule

      #{submission.description}
    DESC
  end

  def create_test_event(submission)
    Rails.logger.info "Creating test event..."

    if submission.virtual_meeting_type == Submission::ZOOM_MEETING_TYPE
      meeting = zoom_client.meeting_create(
        topic: title_for(submission, "TEST RUN"),
        type: 2,
        start_time: Time.now.iso8601,
        duration: submission.preferred_length.to_i,
        timezone: "America/Denver",
        agenda: description_for(submission),
        settings: DEFAULT_MEETING_SETTINGS
      )

      if submission.broadcast_on_youtube_live?
        stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::TEST_KIND).first!
        zoom_client.livestream(
          meeting_id: meeting["id"],
          stream_url: stream.ingestion_address,
          stream_key: stream.stream_name
          # page_url:
        )
      end
      save_event(submission, Submission::ZOOM_MEETING_TYPE, meeting, ZoomEvent::TEST_KIND)
    elsif submission.virtual_meeting_type == Submission::ZOOM_WEBINAR_TYPE
      event = zoom_client.webinar_create(
        host_id: "me",
        topic: title_for(submission, "TEST RUN"),
        type: 5,
        start_time: Time.now.iso8601,
        duration: submission.preferred_length.to_i,
        timezone: "America/Denver",
        agenda: description_for(submission),
        settings: DEFAULT_WEBINAR_SETTINGS
      )

      if submission.broadcast_on_youtube_live?
        stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::TEST_KIND).first!
        zoom_client.livestream(
          meeting_id: event["id"],
          stream_url: stream.ingestion_address,
          stream_key: stream.stream_name
          # page_url:
        )
      end
      save_event(submission, Submission::ZOOM_WEBINAR_TYPE, event, ZoomEvent::TEST_KIND)
    end
  end

  def create_live_event(submission)
    Rails.logger.info "Creating live event..."

    if submission.virtual_meeting_type == Submission::ZOOM_MEETING_TYPE
      meeting = zoom_client.meeting_create(
        topic: title_for(submission),
        type: 2,
        start_time: submission.start_datetime.iso8601,
        duration: submission.preferred_length.to_i,
        timezone: "America/Denver",
        agenda: description_for(submission),
        settings: DEFAULT_MEETING_SETTINGS
      )

      if submission.broadcast_on_youtube_live?
        stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).first!
        zoom_client.livestream(
          meeting_id: meeting["id"],
          stream_url: stream.ingestion_address,
          stream_key: stream.stream_name
          # page_url:
        )
      end
      save_event(submission, Submission::ZOOM_MEETING_TYPE, meeting, ZoomEvent::LIVE_KIND)
    elsif submission.virtual_meeting_type == Submission::ZOOM_WEBINAR_TYPE
      event = zoom_client.webinar_create(
        host_id: "me",
        topic: title_for(submission),
        type: 5,
        start_time: submission.start_datetime.iso8601,
        duration: submission.preferred_length.to_i,
        timezone: "America/Denver",
        agenda: description_for(submission),
        settings: DEFAULT_WEBINAR_SETTINGS
      )

      if submission.broadcast_on_youtube_live?
        stream = submission.youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).first!
        zoom_client.livestream(
          meeting_id: event["id"],
          stream_url: stream.ingestion_address,
          stream_key: stream.stream_name
          # page_url:
        )
      end
      save_event(submission, Submission::ZOOM_WEBINAR_TYPE, event, ZoomEvent::LIVE_KIND)
    end
  end

  def save_event(submission, type, event, kind)
    submission.zoom_events.create!(
      oauth_service: submission.zoom_oauth_service,
      zoom_id: event["id"],
      join_url: event["join_url"],
      host_url: event["start_url"],
      event_type: type,
      kind: kind
    )
  end

  def test_event_exists?(submission)
    submission.zoom_events.where(kind: ZoomEvent::TEST_KIND).any?
  end

  def live_event_exists?(submission)
    submission.zoom_events.where(kind: ZoomEvent::LIVE_KIND).any?
  end
end
