require "rails_helper"

RSpec.describe JobFairSignupTimeSlot, type: :model do
  it { is_expected.to belong_to(:job_fair_signup) }
  it { is_expected.to belong_to(:submission) }
end
