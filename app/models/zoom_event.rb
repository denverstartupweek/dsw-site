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

  belongs_to :submission

  validates :zoom_id, presence: true
  validates :event_type, presence: true, inclusion: {in: EVENT_TYPES}
  validates :kind, presence: true, inclusion: {in: KINDS}
end
