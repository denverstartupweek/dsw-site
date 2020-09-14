class Submission < ApplicationRecord
  EMAILS_SPLIT_REGEX = %r{\s*(?:\s|;|,)\s*}.freeze
  PUBLIC_STATES = %w[open_for_voting accepted confirmed venue_confirmed].freeze

  SHOW_RATE = 0.3

  FORMATS = [
    "Individual Presentation",
    "Panel",
    "Workshop",
    "Social event"
  ].freeze

  PREFERRED_LENGTHS = [
    "10 minutes",
    "30 minutes",
    "60 minutes",
    "90 minutes"
  ].freeze

  DAYS = {
    2 => "Monday",
    3 => "Tuesday",
    4 => "Wednesday",
    5 => "Thursday",
    6 => "Friday"
  }.freeze

  SHORT_DAYS = {
    2 => "Mon",
    3 => "Tue",
    4 => "Wed",
    5 => "Thu",
    6 => "Fri"
  }.freeze

  TIME_RANGES = [
    "Early morning",
    "Breakfast",
    "Morning",
    "Lunch",
    "Early afternoon",
    "Afternoon",
    "Happy hour",
    "Evening",
    "Late night"
  ].freeze

  ZOOM_MEETING_TYPE = "zoom"
  ZOOM_WEBINAR_TYPE = "zoom_webinar"
  OTHER_MEETING_TYPE = "other_url"
  VIRTUAL_MEETING_TYPES = [
    ZOOM_MEETING_TYPE,
    ZOOM_WEBINAR_TYPE,
    OTHER_MEETING_TYPE
  ].freeze

  include SearchableSubmission
  include YearScoped
  include Publishable

  has_paper_trail

  mount_uploader :header_image, HeaderImageUploader
  process_in_background :header_image

  belongs_to :submitter, class_name: "User"
  belongs_to :track
  belongs_to :venue, optional: true
  belongs_to :company, optional: true
  belongs_to :cluster, optional: true

  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :session_registrations, dependent: :destroy
  has_many :user_registrations, through: :session_registrations,
                                class_name: "Registration",
                                source: :registration
  has_many :registrants, through: :user_registrations,
                         class_name: "User",
                         source: :user

  has_many :sent_notifications, as: :subject, dependent: :destroy
  has_many :attendee_messages, dependent: :restrict_with_error
  has_many :feedback, dependent: :destroy
  has_one :sponsorship, dependent: :restrict_with_error
  has_many :presenterships, dependent: :destroy
  has_many :presenters, through: :presenterships, source: :user
  has_many :youtube_live_streams, dependent: :restrict_with_error
  has_many :zoom_events, dependent: :restrict_with_error
  has_many :zoom_join_urls, through: :zoom_events
  belongs_to :zoom_oauth_service, optional: true, class_name: "OauthService"
  has_many :job_fair_signup_time_slots, dependent: :restrict_with_error
  has_many :job_fair_signups, through: :job_fair_signup_time_slots

  accepts_nested_attributes_for :publishing, allow_destroy: false
  accepts_nested_attributes_for :presenterships, allow_destroy: true

  delegate :video_required_for_submission?, to: :track, allow_nil: true, prefix: true

  validates :title,
    :description,
    :contact_email, presence: true
  validates :proposal_video_url,
    presence: true,
    on: :create,
    if: :track_video_required_for_submission?
  validates :format, inclusion: {in: FORMATS,
                                 allow_blank: true}
  validates :preferred_length, inclusion: {in: PREFERRED_LENGTHS,
                                           allow_blank: true}
  # validates :start_day, inclusion: {  in: DAYS,
  # allow_blank: true }
  # validates :end_day, inclusion: {  in: DAYS,
  # allow_blank: true }
  # validates :time_range, inclusion: { in: TIME_RANGES,
  # allow_blank: true }
  # validates :start_hour, numericality: { greater_than_or_equal_to: 0, less_than: 24 }
  # validates :end_hour, numericality: { greater_than_or_equal_to: 0, less_than: 24 }
  validates :track_id, presence: true
  validates :coc_acknowledgement,
    :dei_acknowledgement,
    acceptance: true, on: :create
  validates :location, length: {maximum: 255}

  validates :virtual_meeting_type,
    inclusion: {
      in: VIRTUAL_MEETING_TYPES,
      allow_blank: true
    },
    if: :is_virtual?

  after_create :notify_track_chairs_of_new_submission!
  after_create :send_confirmation_notice!
  after_save :subscribe_to_list!
  after_save :create_or_update_streams!

  after_initialize do
    self.year ||= Date.today.year
  end

  def to_param
    "#{id}-#{full_title.try(:parameterize)}"
  end

  def contact_emails
    contact_email.split(EMAILS_SPLIT_REGEX).map(&:strip)
  end

  def self.for_public
    where(state: PUBLIC_STATES)
  end

  def self.for_submittable_tracks
    joins(:track)
      .where(tracks: {is_submittable: true})
  end

  def self.for_track(name)
    return all if name == "all" || name.blank?
    joins(:track).where("LOWER(tracks.name) = LOWER(?)", name)
  end

  def self.for_cluster(name)
    return all if name == "all" || name.blank?
    joins(:cluster).where("LOWER(clusters.name) = LOWER(?)", name)
  end

  def self.for_publishings_filter(filters)
    return published if filters.blank?

    published
      .for_track(filters[:track])
      .for_cluster(filters[:cluster])
      .fulltext_search(filters[:terms])
  end

  def self.for_schedule_filter(filter, user)
    if filter == "all"
      all
    elsif filter == "mine" && user
      my_schedule(user)
    elsif filter.present?
      references(:tracks, :clusters)
        .where("LOWER(clusters.name) = LOWER(:name) OR LOWER(tracks.name) = LOWER(:name)", name: filter)
    else
      all
    end
  end

  def self.my_schedule(user)
    joins(:user_registrations)
      .where(registrations: {user_id: user.id})
  end

  def self.live(as_of)
    for_year(as_of.year)
      .for_public
      .where("start_day = ?", AnnualSchedule.day_index(as_of))
      .where("(start_hour < :now AND end_hour > :now)", now: (as_of.hour + as_of.min.to_f / 60))
      .order("start_day ASC, start_hour ASC")
  end

  def self.upcoming(as_of, limit)
    for_year(as_of.year)
      .for_public
      .where("start_day >= ?", AnnualSchedule.day_index(as_of))
      .where("start_hour >= :now", now: (as_of.hour + as_of.min.to_f / 60))
      .order("start_day ASC, start_hour ASC")
      .limit(limit)
  end

  def self.livestreamed
    where(broadcast_on_youtube_live: true)
  end

  def self.for_virtual_job_fair
    where(is_virtual_job_fair_slot: true).order(start_day: :asc, start_hour: :asc)
  end

  def public?
    PUBLIC_STATES.include?(state)
  end

  def editable?
    !(rejected? || withdrawn?)
  end

  def open_for_feedback?
    AnnualSchedule.current.in_week? || AnnualSchedule.current.post_week? || year < AnnualSchedule.current.year
  end

  def self.for_schedule
    where(state: %w[confirmed venue_confirmed])
      .where("start_day IS NOT NULL AND end_day IS NOT NULL")
  end

  def self.for_start_day(day)
    if (day_index = DAYS.invert[day.titleize])
      where(start_day: day_index)
    else
      all
    end
  end

  def self.with_slides_or_video
    where("(slides_url IS NOT NULL AND slides_url <> '') OR (video_url IS NOT NULL AND video_url <> '')")
      .order("year DESC")
  end

  def self.pitch_qualifying
    where(pitch_qualifying: true)
  end

  # State machine
  include SimpleStates

  states :created,
    :on_hold,
    :open_for_voting,
    :accepted,
    :waitlisted,
    :confirmed,
    :venue_confirmed,
    :rejected,
    :withdrawn

  event :place_on_hold, to: :on_hold
  event :open_for_voting, to: :open_for_voting
  event :waitlist, to: :waitlisted
  event :accept, to: :accepted
  event :reject, to: :rejected
  event :confirm, to: :confirmed
  event :confirm_venue, to: :venue_confirmed
  event :withdraw, to: :withdrawn

  # Helpers
  def subtitle_for_schedule
    if is_virtual?
      format
    else
      human_location_name
    end
  end

  def human_location_name
    if venue_confirmed?
      venue.name
    else
      "Location TBA"
    end
  end

  def human_start_day
    DAYS[start_day]
  end

  def human_short_start_day
    SHORT_DAYS[start_day]
  end

  def human_end_day
    DAYS[end_day]
  end

  def human_short_end_day
    SHORT_DAYS[end_day]
  end

  def ical_location
    if venue_confirmed?
      "#{venue.name}, #{venue.combined_address}"
    else
      "Location TBA"
    end
  end

  def current_year?
    year == Date.today.year
  end

  def start_datetime
    datetime = schedule.week_start_at.in_time_zone("America/Denver") + (start_day.to_i - 2).days
    datetime += start_hour.hours if start_hour
    datetime
  end

  def end_datetime
    datetime = schedule.week_start_at.in_time_zone("America/Denver") + (end_day.to_i - 2).days
    datetime += end_hour.hours if end_hour
    datetime
  end

  def human_time_range(separator = "&mdash;")
    "#{human_start_time} #{separator} #{human_end_time}".html_safe
  end

  def human_start_date_time_range
    "#{human_start_day} #{human_time_range}".html_safe
  end

  def human_start_time
    start_hour.hours.since(Date.today.beginning_of_day).strftime("%l:%M%P")
  end

  def human_end_time
    end_hour.hours.since(Date.today.beginning_of_day).strftime("%l:%M%P")
  end

  def time_assigned?
    start_hour.present? &&
      end_hour.present? &&
      start_day.present? &&
      end_day.present?
  end

  def to_ics
    event
  end

  def tags
    {}.tap do |t|
      t[cluster.name] = cluster.description if cluster
      t["Popular"] = I18n.t("tag_descriptions.popular") if popular?
      t["Childcare"] = I18n.t("tag_descriptions.childcare") if has_childcare?
    end
  end

  def popular?
    user_registrations.count * SHOW_RATE > (venue.try(:seated_capacity) || Venue::DEFAULT_CAPACITY)
  end

  def venue_confirmed?
    venue.present? && state == "venue_confirmed".freeze
  end

  def company_or_submitter
    if company_name.present?
      "#{submitter.name} (#{company_name})"
    else
      submitter.name
    end
  end

  def full_title
    if sponsorship.present?
      "#{title} sponsored by #{sponsorship.name}"
    else
      title
    end
  end

  def company_name
    company.try(:name)
  end

  def company_name=(value)
    self.company = Company.where("LOWER(name) = LOWER(?)", value).first_or_initialize(name: value)
  end

  def public_registrants(current_user)
    registrants
      .where(show_attendance_publicly: true)
      .reorder([Arel.sql(<<-SQL), current_user.id])
        (CASE WHEN users.id = ? THEN 1 ELSE 2 END) ASC,
        "session_registrations"."created_at" DESC
      SQL
  end

  def join_url
    if virtual_meeting_type == Submission::OTHER_MEETING_TYPE
      virtual_join_url
    else
      zoom_events.where(kind: ZoomEvent::LIVE_KIND).first.try(:join_url)
    end
  end

  def stream_url
    if broadcast_on_youtube_live?
      youtube_id = youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).first.try(:broadcast_id)
      if youtube_id
        "https://www.youtube.com/embed/#{youtube_id}"
      else
        "https://www.youtube.com/c/denverstartupweek"
      end
    else
      live_stream_url
    end
  end

  # Actions
  def create_or_update_streams!
    CreateOrUpdateVideoIntegrationsJob.perform_async(id)
  end

  def send_venue_match_email!
    message = NotificationsMailer.notify_of_submission_venue_match(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::VENUE_MATCH_KIND,
                               recipient_email: message.to.join(", ")
  end

  def send_accept_email!
    message = NotificationsMailer.notify_of_submission_acceptance(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::ACCEPTANCE_KIND,
                               recipient_email: message.to.join(", ")
  end

  def send_reject_email!
    message = NotificationsMailer.notify_of_submission_rejection(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::REJECTION_KIND,
                               recipient_email: message.to.join(", ")
  end

  def send_waitlist_email!
    message = NotificationsMailer.notify_of_submission_waitlisting(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::WAITLISTING_KIND,
                               recipient_email: message.to.join(", ")
  end

  def send_thanks_email!
    message = NotificationsMailer.session_thanks(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::THANKS_KIND,
                               recipient_email: message.to.join(", ")
  end

  def promote_updates!
    with_lock do
      update((proposed_updates || {}).merge(proposed_updates: nil))
    end
    notify_submitter_of_update_acceptance!
  end

  def notify_submitter_of_update_acceptance!
    message = NotificationsMailer.notify_of_update_acceptance(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::UPDATES_ACCEPTED_KIND,
                               recipient_email: message.to.join(", ")
  end

  def notify_track_chairs_of_update!(reminder = false)
    track.chairs.each do |chair|
      NotificationsMailer.notify_of_submission_update(chair, self, reminder).deliver_now
    end
  end

  def notify_track_chairs_of_new_submission!
    track.chairs.each do |chair|
      NotificationsMailer.notify_of_new_submission(chair, self).deliver_now
    end
  end

  def send_confirmation_notice!
    NotificationsMailer.confirm_new_submission(self).deliver_now
  end

  def subscribe_to_list!
    [contact_emails, submitter.try(:email)].flatten.compact.uniq.each do |email|
      submitted_years = Submission
        .joins(:submitter)
        .where("contact_email ILIKE :email_like OR users.email = :email",
          email_like: "%#{email}%",
          email: email)
        .pluck(:year)
        .sort
        .uniq
        .map(&:to_s)
      confirmed_years = Submission
        .where(state: %w[accepted confirmed venue_confirmed])
        .joins(:submitter)
        .where("contact_email ILIKE :email_like OR users.email = :email",
          email_like: "%#{email}%",
          email: email)
        .pluck(:year)
        .sort
        .uniq
        .map(&:to_s)
      ListSubscriptionJob.perform_async(email,
        submitted_years: submitted_years,
        confirmed_years: confirmed_years)
    end
  end

  # Recommendation logic
  # Based off of https://github.com/geoffreylitt/simple_recommender
  # Customized to scope to the current year

  def refresh_similar_item_cache!
    update_column :cached_similar_item_ids, similar_items.map(&:id)
  end

  def similar_items(num = 10)
    sql = <<-EOF
      WITH similar_items AS (
        SELECT
        t2.submission_id,
        (# (array_agg(DISTINCT t1.registration_id) & array_agg(DISTINCT t2.registration_id)))::float/
        (# (array_agg(DISTINCT t1.registration_id) | array_agg(DISTINCT t2.registration_id)))::float as similarity
        FROM session_registrations AS t1, session_registrations AS t2
        INNER JOIN registrations ON t2.registration_id = registrations.id AND registrations.year = :year
        WHERE t1.submission_id = :id and t2.submission_id != :id
        GROUP BY t2.submission_id
        ORDER BY similarity DESC
        LIMIT :num
      )
      SELECT submissions.*, similarity
      FROM similar_items
      JOIN submissions ON submissions.id = similar_items.submission_id
      ORDER BY similarity DESC;
    EOF
    self.class.find_by_sql(ActiveRecord::Base.send(:sanitize_sql_array, [sql, id: id, year: year, num: num]))
  end

  def cached_similar_items
    order = ActiveRecord::Base.send(:sanitize_sql_array, ["position(id::text in ?)", cached_similar_item_ids.join(",")])
    self.class.where(id: cached_similar_item_ids).order(Arel.sql(order))
  end

  private

  def schedule
    AnnualSchedule.find_by!(year: year)
  end
end
