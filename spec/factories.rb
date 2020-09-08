FactoryBot.define do
  factory :annual_schedule do
    # This is the actual 2017 schedule for reference
    year { 2017 }
    cfp_open_at { Date.parse("2017-03-19").freeze }
    cfp_close_at { Date.parse("2017-04-21").freeze }
    voting_open_at { Date.parse("2017-05-10").freeze }
    voting_close_at { Date.parse("2017-05-29").freeze }
    registration_open_at { Date.parse("2017-07-20").freeze }
    week_start_at { Date.parse("2017-09-25").freeze }
    week_end_at { Date.parse("2017-09-29").freeze }
    pitch_application_open_at { Date.parse("2017-08-08").freeze }
    pitch_application_close_at { Date.parse("2017-08-31").freeze }
    pitch_voting_open_at { Date.parse("2017-09-12").freeze }
    pitch_voting_close_at { Date.parse("2017-09-22").freeze }
    sponsorship_open_at { Date.parse("2017-03-01").freeze }
    sponsorship_close_at { Date.parse("2017-09-09").freeze }
    ambassador_application_open_at { Date.parse("2017-07-01").freeze }
    ambassador_application_close_at { Date.parse("2017-08-11").freeze }
  end

  factory :article do
    title { "This is a good article" }
    body { "Please read me!" }
    association :submitter, factory: :user
  end

  factory :attendee_goal

  factory :attendee_message do
    association :submission
    subject { "Important" }
    body { "I am a message!" }
  end

  factory :cluster

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
  end

  factory :ethnicity

  factory :general_inquiry do
    sequence(:contact_email) { |n| "#{n}@example.com" }
  end

  factory :newsroom_item do
    title { "Good news!" }
    release_date { 1.day.ago }
  end

  factory :publishing do
    effective_at { Time.zone.now }
  end

  factory :registration do
    association :user
    association :track
    age_range { Registration::AGE_RANGES.first }
    primary_role { "Founder" }
    coc_acknowledgement { true }
  end

  factory :submission do
    sequence(:title) { |n| "Session #{n}" }
    description { "I am a session" }
    contact_email { "test@example.com" }
    coc_acknowledgement { true }
    dei_acknowledgement { true }
    association :track
    association :submitter, factory: :user
  end

  factory :track do
    sequence(:name) { |n| "Track #{n}" }
    email_alias { "#{name.parameterize}@example.com" }
    color { "teal" }
    icon { "eyeball" }
    has_detail_page { true }
    is_submittable { true }
  end

  factory :user do
    name { "Erlich Bachmann" }
    password { "password" }
    password_confirmation { password }
    sequence(:email) { |n| "user#{n}@example.com" }
    file_path = Rails.root.join("spec", "support", "avatar_examples", "less_than_2_mb.png")
    avatar { Rack::Test::UploadedFile.new(file_path, "image/png") }
  end

  factory :venue do
    sequence(:name) { |n| "Venue #{n}" }
    address { "1060 W Addison St" }
    city { "Chicago" }
    state { "IL" }
  end

  factory :job_fair_signup do
    association :user
    association :company
    number_open_positions { 10 }
    number_hiring_next_12_months { 20 }
    organization_size { JobFairSignup::ORGANIZATION_SIZES.sample }
    industry_category { JobFairSignup::INDUSTRY_CATEGORIES.sample }
  end

  factory :oauth_service do
    association :user
    provider { OauthService::YOUTUBE_PROVIDER }
    sequence(:uid) { |n| "u#{n}" }
  end
end
