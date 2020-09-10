require "spec_helper"

RSpec.describe Registration, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:attendee_goals) }
  it { is_expected.to have_many(:registration_attendee_goals).dependent(:destroy) }
  it { is_expected.to have_many(:registration_ethnicities).dependent(:destroy) }
  it { is_expected.to have_many(:session_registrations).dependent(:destroy) }
  it { is_expected.to have_many(:submissions) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:age_range) }
  it { is_expected.to validate_presence_of(:primary_role) }
  it { is_expected.to validate_acceptance_of(:coc_acknowledgement) }

  describe "with an existing registration" do
    subject { create(:registration) }

    it do
      is_expected.to validate_uniqueness_of(:user_id)
        .scoped_to(:year)
        .with_message("may only register once per year")
    end
  end

  describe "with an existing registration" do
    subject { create(:registration) }

    it do
      is_expected.to validate_uniqueness_of(:user_id)
        .scoped_to(:year)
        .with_message("may only register once per year")
    end
  end

  it "defaults its year to the current year" do
    expect(Registration.new.year).to eq(Date.today.year)
  end

  it "defaults its calendar_token to a random value" do
    expect(Registration.new.calendar_token).not_to be_empty
  end

  context "subscribing to mailing lists" do
    let(:user) do
      create(:user, name: "Test User",
                    email: "test@example.com",
                    password: "password")
    end

    it "subscribes automatically on creation" do
      create(:registration,
        user: user,
        contact_email: "test@example.com",
        year: 2015)
      expect(ListSubscriptionJob).to have_received(:perform_async).with("test@example.com",
        registered_years: ["2015"])
    end

    it "sends multiple registration years if applicable" do
      create(:registration,
        user: user,
        contact_email: "test@example.com",
        year: 2015,
        age_range: Registration::AGE_RANGES.first,
        primary_role: "Testing",
        coc_acknowledgement: true)
      create(:registration,
        user: user,
        contact_email: "test@example.com",
        year: 2016,
        age_range: Registration::AGE_RANGES.first,
        primary_role: "Testing",
        coc_acknowledgement: true)
      expect(ListSubscriptionJob).to have_received(:perform_async).with("test@example.com",
        registered_years: %w[2015 2016])
    end
  end
end
