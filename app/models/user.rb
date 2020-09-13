class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :trackable,
    :validatable

  default_scope { order(name: :asc) }

  validates :name, presence: true

  validates :team_priority,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 10,
      allow_nil: true
    }

  validates :linkedin_url, format: {
    with: /(.*)linkedin.com\/in\/(.*)/,
    allow_blank: true
  }

  include ValidateEmail

  has_many :submissions, foreign_key: "submitter_id", dependent: :restrict_with_error
  has_many :votes, dependent: :destroy
  has_many :feedback, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :pitch_contest_votes, class_name: "PitchContest::Vote", dependent: :destroy
  has_many :authorships, dependent: :restrict_with_error
  has_many :articles, foreign_key: "submitter_id", dependent: :restrict_with_error
  has_many :venue_adminships, dependent: :destroy
  has_many :administered_venues, through: :venue_adminships, class_name: "Venue", source: :venue
  has_many :job_fair_signups, dependent: :restrict_with_error
  has_many :oauth_services, dependent: :restrict_with_error
  has_many :zoom_join_urls, dependent: :destroy

  has_and_belongs_to_many :chaired_tracks, class_name: "Track"
  has_and_belongs_to_many :companies
  has_many :venues, through: :companies

  has_one :cfp_extension, dependent: :destroy
  accepts_nested_attributes_for :cfp_extension

  def has_valid_cfp_extension?
    cfp_extension.present? &&
      (cfp_extension.expires_at.at_end_of_day > Time.zone.now)
  end

  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar

  def self.on_team
    reorder("team_priority ASC, team_position DESC, name DESC")
      .where("team_position IS NOT NULL AND team_position <> ''")
  end

  has_many :presenterships, dependent: :restrict_with_error
  has_many :presented_sessions, through: :presenterships, source: :submission

  def current_registration
    registrations.for_current_year.first
  end

  def registered?
    current_registration.present?
  end

  def initials
    name.split(" ").map { |n| n[0, 1] }.join
  end

  def abbreviated_name
    parts = name.split
    if parts.size > 1
      [parts.first, parts.last[0]].compact.join(" ") + "."
    else
      name
    end
  end

  before_save :normalize_linkedin_url!
  def normalize_linkedin_url!
    if linkedin_url.present?
      self.linkedin_url = Addressable::URI.heuristic_parse(linkedin_url).normalize.to_s
    end
  end
end
