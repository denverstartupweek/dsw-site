require "spec_helper"

RSpec.describe GeneralInquiry, type: :model do
  it { is_expected.to allow_value(nil).for(:interest) }
  it { is_expected.to allow_value("").for(:interest) }
  it { is_expected.to allow_value("volunteer").for(:interest) }
  it { is_expected.to allow_value("crawl").for(:interest) }
  it { is_expected.not_to allow_value("blah").for(:interest) }

  it "subscribes after creation" do
    create(:general_inquiry, contact_email: "test@example.com")
    expect(ListSubscriptionJob).to have_received(:perform_async).with("test@example.com")
  end
end
