# frozen_string_literal: true

class SentNotification < ApplicationRecord
  ACCEPTANCE_KIND = "accepted"
  REJECTION_KIND = "rejected"
  VENUE_MATCH_KIND = "venue_match"
  WAITLISTING_KIND = "waitlisted"
  THANKS_KIND = "thanks"
  UPDATES_ACCEPTED_KIND = "updates_accepted"
  JOB_FAIR_SIGNUP_ACCEPTED_KIND = "job_fair_signup_accepted"

  KINDS = [
    ACCEPTANCE_KIND,
    REJECTION_KIND,
    VENUE_MATCH_KIND,
    WAITLISTING_KIND,
    THANKS_KIND,
    UPDATES_ACCEPTED_KIND,
    JOB_FAIR_SIGNUP_ACCEPTED_KIND
  ].freeze

  belongs_to :subject, polymorphic: true

  validates :kind, presence: true, inclusion: {in: KINDS}
  validates :recipient_email, presence: true
end
