require "rails_helper"

RSpec.describe JobFairRole, type: :model do
  it { is_expected.to belong_to(:job_fair_signup) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:url) }
end
