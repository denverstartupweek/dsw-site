require "spec_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:submissions).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:registrations).dependent(:destroy) }
  it { is_expected.to have_many(:pitch_contest_votes).dependent(:destroy) }
  it { is_expected.to have_and_belong_to_many(:chaired_tracks).class_name("Track") }
  it { is_expected.to have_many(:venue_adminships).dependent(:destroy) }
  it { is_expected.to have_many(:administered_venues) }
  it { is_expected.to have_many(:oauth_services).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:presenterships).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:presented_sessions) }
  it { is_expected.to have_many(:zoom_join_urls).dependent(:destroy) }
  it { is_expected.to have_one(:cfp_extension) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to allow_value(0).for(:team_priority) }
  it { is_expected.to allow_value(10).for(:team_priority) }
  it { is_expected.to allow_value(5).for(:team_priority) }
  it { is_expected.to allow_value(nil).for(:team_priority) }
  it { is_expected.not_to allow_value(-1).for(:team_priority) }
  it { is_expected.not_to allow_value(100).for(:team_priority) }

  it { is_expected.to allow_value(nil).for(:linkedin_url) }
  it { is_expected.to allow_value("https://www.linkedin.com/in/jayzes").for(:linkedin_url) }
  it { is_expected.to allow_value("http://www.linkedin.com/in/jayzes").for(:linkedin_url) }
  it { is_expected.to allow_value("linkedin.com/in/jayzes").for(:linkedin_url) }
  it { is_expected.not_to allow_value("http://www.google.com/").for(:linkedin_url) }

  describe "with a subject record present" do
    subject { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "normalizing linkedin URLs" do
    it "turns a URL with no scheme into an absolute URL" do
      u = create(:user, linkedin_url: "linkedin.com/in/jayzes/")
      expect(u.linkedin_url).to eq("http://linkedin.com/in/jayzes/")
    end

    it "deals sanely with empty URLs" do
      u = create(:user, linkedin_url: nil)
      expect(u.linkedin_url).to be_nil
    end

    it "leaves a URL with a scheme alone" do
      u = create(:user, linkedin_url: "https://www.linkedin.com/in/jayzes/")
      expect(u.linkedin_url).to eq("https://www.linkedin.com/in/jayzes/")
    end
  end

  describe "deriving initials" do
    it "works when a first and last name are specified" do
      u = build(:user, name: "Jay Zeschin")
      expect(u.initials).to eq("JZ")
    end

    it "doesn't explode when a name is empty" do
      u = build(:user, name: "")
      expect(u.initials).to be_blank
    end

    it "works when only a first name is specified" do
      u = build(:user, name: "Jay")
      expect(u.initials).to eq("J")
    end

    it "works when multiple last names are specified" do
      u = build(:user, name: "Jay Zeschin Smith")
      expect(u.initials).to eq("JZS")
    end
  end

  describe "deriving an abbreviated name" do
    it "works when a first and last name are specified" do
      u = build(:user, name: "Jay Zeschin")
      expect(u.abbreviated_name).to eq("Jay Z.")
    end

    it "works when only a first name is specified" do
      u = build(:user, name: "Jay")
      expect(u.abbreviated_name).to eq("Jay")
    end

    it "works when multiple last names are specified" do
      u = build(:user, name: "Jay Zeschin Smith")
      expect(u.abbreviated_name).to eq("Jay S.")
    end

    it "doesn't explode when a name is empty" do
      u = build(:user, name: "")
      expect(u.abbreviated_name).to be_blank
    end
  end
end
