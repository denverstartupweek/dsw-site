class ZoomEvent < ApplicationRecord
  TEST_KIND = "test"
  LIVE_KIND = "live"
  KINDS = [
    TEST_KIND,
    LIVE_KIND
  ].freeze

  EVENT_TYPES = [
    Submission::ZOOM_MEETING_TYPE,
    Submission::ZOOM_WEBINAR_TYPE
  ].freeze

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
    registrants_confirmation_email: false
  }

  DEFAULT_WEBINAR_SETTINGS = {
    host_video: false,
    panelists_video: true,
    practice_session: true,
    hd_video: true,
    approval_type: 2,
    audio: "both",
    auto_recording: "cloud",
    allow_multiple_devices: true,
    registrants_confirmation_email: false,
    meeting_authentication: false,
    post_webinar_survey: true
  }

  belongs_to :submission
  belongs_to :oauth_service

  validates :zoom_id, presence: true
  validates :event_type, presence: true, inclusion: {in: EVENT_TYPES}
  validates :kind, presence: true, inclusion: {in: KINDS}

  before_destroy :destroy_on_zoom!

  # TODO: Tests
  def create_on_zoom!
    oauth_service.refresh_if_needed!
    event = if event_type == Submission::ZOOM_MEETING_TYPE
      oauth_service.zoom_client.meeting_create(zoom_meeting_params)
    elsif event_type == Submission::ZOOM_WEBINAR_TYPE
      oauth_service.zoom_client.webinar_create(
        zoom_webinar_params.deep_merge(
          settings: {
            survey_url: Rails.application.routes.url_helpers.schedule_url(submission)
          }
        )
      )
    end
    update!(
      zoom_id: event["id"],
      join_url: event["join_url"],
      host_url: event["start_url"]
    )
  end

  # TODO: Tests
  def update_on_zoom!
    oauth_service.refresh_if_needed!
    if event_type == Submission::ZOOM_MEETING_TYPE
      oauth_service.zoom_client.meeting_update(zoom_meeting_params.merge(meeting_id: zoom_id).except(:user_id))
    elsif event_type == Submission::ZOOM_WEBINAR_TYPE
      oauth_service.zoom_client.webinar_update(
        zoom_webinar_params.merge(
          id: zoom_id,
          settings: {
            survey_url: Rails.application.routes.url_helpers.schedule_url(submission)
          }
        ).except(:host_id)
      )
    end
  end

  # TODO: Tests
  def destroy_on_zoom!
    oauth_service.refresh_if_needed!
    if event_type == Submission::ZOOM_MEETING_TYPE
      oauth_service.zoom_client.meeting_delete(meeting_id: zoom_id)
    elsif event_type == Submission::ZOOM_WEBINAR_TYPE
      oauth_service.zoom_client.webinar_delete(id: zoom_id)
    end
  end

  # TODO: Tests
  def refresh_urls!
    oauth_service.refresh_if_needed!
    event = if event_type == Submission::ZOOM_MEETING_TYPE
      oauth_service.zoom_client.meeting_get(meeting_id: zoom_id)
    elsif event_type == Submission::ZOOM_WEBINAR_TYPE
      oauth_service.zoom_client.webinar_get(id: zoom_id)
    end
    update!(
      zoom_id: event["id"],
      join_url: event["join_url"],
      host_url: event["start_url"]
    )
  end

  # TODO: Tests
  def update_presenters!
    return unless event_type == Submission::ZOOM_WEBINAR_TYPE
    oauth_service.refresh_if_needed!
    oauth_service.zoom_client.webinar_panelists_add(
      webinar_id: zoom_id,
      panelists: (submission.presenters.to_a << submission.submitter).map do |u|
        {name: u.name, email: u.email}
      end
    )
    oauth_service.zoom_client.webinar_panelists_list(webinar_id: zoom_id)["panelists"].each do |p|
      if (presentership = submission.presenterships.joins(:user).where(users: {email: p["email"]}).first)
        presentership.update!(virtual_join_url: p["join_url"])
      elsif submission.submitter.email == p["email"]
        submission.update!(submitter_virtual_join_url: p["join_url"])
      end
    end
  end

  def zoom_meeting_params
    {
      user_id: "me",
      topic: title,
      type: 2,
      start_time: submission.start_datetime.iso8601,
      duration: submission.preferred_length.to_i,
      timezone: "America/Denver",
      agenda: description,
      settings: DEFAULT_MEETING_SETTINGS
    }
  end

  def zoom_webinar_params
    {
      host_id: "me",
      topic: title,
      type: 5,
      start_time: submission.start_datetime.iso8601,
      duration: submission.preferred_length.to_i,
      timezone: "America/Denver",
      agenda: description,
      settings: DEFAULT_WEBINAR_SETTINGS
    }
  end

  def title
    full_title = "DSW #{submission.year}: #{submission.title}"
    suffix = (kind == TEST_KIND ? " - TEST RUN" : "")
    full_title.truncate(300 - suffix.length) + suffix
  end

  def description
    <<~DESC.strip.truncate(2000)
      This event is part of Denver Startup Week #{submission.year}. Register and view the full schedule of events at https://www.denverstartupweek.org/schedule

      #{submission.description.encode(universal_newline: true)}
    DESC
  end
end
