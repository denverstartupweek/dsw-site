class JobFairSignup < ApplicationRecord
  has_paper_trail

  belongs_to :company
  belongs_to :user
  has_many :job_fair_signup_time_slots, dependent: :destroy
  has_many :submissions, through: :job_fair_signup_time_slots
  has_many :job_fair_roles, dependent: :destroy

  has_many :sent_notifications, as: :subject, dependent: :destroy

  after_save :subscribe_to_list

  INDUSTRY_CATEGORIES = [
    "Software",
    "Digital Marketing",
    "Telecom",
    "Non-profit",
    "Insurance",
    "HR",
    "Transportation",
    "Real Estate",
    "Finance",
    "Hospitality",
    "Construction",
    "Retail",
    "Media",
    "Energy",
    "Health",
    "Technology",
    "Other"
  ].freeze

  ORGANIZATION_SIZES = [
    "1-50 employees",
    "50-150 employees",
    "150-250 employees",
    "Over 250 employees"
  ].freeze

  include YearScoped

  validates :industry_category, presence: true, inclusion: {in: INDUSTRY_CATEGORIES}
  validates :organization_size, presence: true, inclusion: {in: ORGANIZATION_SIZES}
  validates :number_open_positions,
    :number_hiring_next_12_months, presence: true

  # State machine
  include SimpleStates

  states :created,
    :accepted,
    :rejected

  event :accept, to: :accepted
  event :reject, to: :rejected

  def self.accepted
    where(state: "accepted")
  end

  def company_name
    company&.name
  end

  def company_name=(value)
    self.company = Company.where("LOWER(name) = LOWER(?)", value).first_or_initialize(name: value)
  end

  def contact_emails
    contact_email&.split(Submission::EMAILS_SPLIT_REGEX)&.map(&:strip)
  end

  def notification_emails
    [contact_emails, user.email].flatten.uniq
  end

  def subscribe_to_list
    [contact_emails, user.try(:email)].flatten.compact.uniq.each do |email|
      ListSubscriptionJob.perform_async email, job_fair_years: [year.to_s]
    end
  end

  def send_acceptance_email!
    message = NotificationsMailer.confirm_job_fair_signup(self)
    message.deliver_now!
    sent_notifications.create! kind: SentNotification::JOB_FAIR_SIGNUP_ACCEPTED_KIND,
                               recipient_email: message.to.join(", ")
  end
end
