require "rails_helper"

RSpec.describe JobFairSignup, type: :model do
  before do
    allow(ListSubscriptionJob).to receive(:perform_async)
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:sent_notifications).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:industry_category) }
  it { is_expected.to validate_presence_of(:organization_size) }
  it { is_expected.to validate_presence_of(:number_open_positions) }
  it { is_expected.to validate_presence_of(:number_hiring_next_12_months) }

  describe "subscribing to e-mail lists" do
    let(:user) { create(:user) }
    let(:year) { Date.today.year.to_s }

    it "subscribes after creation" do
      create(:job_fair_signup,
        user: user,
        contact_email: "test@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, job_fair_years: [year])
    end

    it "subscribes multiple e-mails after creation when separated with commas" do
      create(:job_fair_signup,
        user: user,
        contact_email: "test1@example.com, test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, job_fair_years: [year])
    end

    it "subscribes multiple e-mails after creation when separated with semicolons" do
      create(:job_fair_signup,
        user: user,
        contact_email: "test1@example.com; test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, job_fair_years: [year])
    end

    it "subscribes multiple e-mails after creation when separated with spaces" do
      create(:job_fair_signup,
        user: user,
        contact_email: "test1@example.com test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", job_fair_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, job_fair_years: [year])
    end
  end
end
