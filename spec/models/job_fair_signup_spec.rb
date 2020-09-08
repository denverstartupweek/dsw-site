require "rails_helper"

RSpec.describe JobFairSignup, type: :model do
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

  describe "sending e-mails" do
    let(:user) do
      create(:user, email: "user@example.com")
    end

    let(:signup) do
      create(:job_fair_signup, user: user, contact_email: "test1@example.com, test2@example.com")
    end

    it "sends and records an acceptance e-mail" do
      signup.send_acceptance_email!
      expect(signup.sent_notifications.size).to eq(1)
      last_sent_notification = signup.sent_notifications.last
      expect(last_sent_notification.kind).to eq(SentNotification::JOB_FAIR_SIGNUP_ACCEPTED_KIND)
      expect(last_sent_notification.recipient_email).to eq("test1@example.com, test2@example.com, user@example.com")

      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to eq("Your job fair signup for Denver Startup Week #{Date.today.year} has been accepted")
    end
  end
end
