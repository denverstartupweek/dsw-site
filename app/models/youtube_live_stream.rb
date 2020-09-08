class YoutubeLiveStream < ApplicationRecord
  TEST_KIND = "test"
  LIVE_KIND = "live"
  KINDS = [
    TEST_KIND,
    LIVE_KIND
  ].freeze

  belongs_to :submission
  validates :kind, presence: true, inclusion: {in: KINDS}
end
