require "spec_helper"

RSpec.describe Submission, type: :model do
  it { is_expected.to belong_to(:track) }
  it { is_expected.to belong_to(:venue).optional }
  it { is_expected.to belong_to(:cluster).optional }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:session_registrations).dependent(:destroy) }
  it { is_expected.to have_many(:user_registrations) }
  it { is_expected.to have_many(:registrants) }
  it { is_expected.to have_many(:sent_notifications).dependent(:destroy) }
  it { is_expected.to have_many(:attendee_messages).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:feedback).dependent(:destroy) }
  it { is_expected.to have_one(:publishing).dependent(:destroy) }

  it { is_expected.to have_many(:presenterships).dependent(:destroy) }
  it { is_expected.to have_many(:presenters) }
  it { is_expected.to have_many(:youtube_live_streams).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:zoom_events).dependent(:restrict_with_error) }
  it { is_expected.to belong_to(:zoom_oauth_service).optional }
  it { is_expected.to have_many(:job_fair_signup_time_slots).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:job_fair_signups).through(:job_fair_signup_time_slots) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:contact_email) }
  # it { is_expected.to ensure_inclusion_of(:format).in_array(Submission::FORMATS) }
  # it { is_expected.to ensure_inclusion_of(:start_day).in_array(Submission::DAYS) }
  # it { is_expected.to ensure_inclusion_of(:end_day).in_array(Submission::DAYS) }
  # it { is_expected.to ensure_inclusion_of(:time_range).in_array(Submission::TIME_RANGES) }
  it { is_expected.to validate_acceptance_of(:coc_acknowledgement).on(:create) }
  it { is_expected.to validate_acceptance_of(:dei_acknowledgement).on(:create) }
  it { is_expected.to allow_value("test@example.com").for(:contact_email) }
  it { is_expected.to validate_length_of(:location).is_at_most(255) }
  it { is_expected.to validate_inclusion_of(:preferred_length).in_array(Submission::PREFERRED_LENGTHS) }
  it { is_expected.to validate_inclusion_of(:format).in_array(Submission::FORMATS) }

  describe "virtual sessions" do
    before { allow(subject).to receive(:is_virtual?).and_return(true) }
    it { is_expected.to validate_inclusion_of(:virtual_meeting_type).in_array(Submission::VIRTUAL_MEETING_TYPES) }
  end

  it "defaults its year to the current year" do
    expect(Submission.new.year).to eq(Date.today.year)
  end

  describe "validating video depending on a track setting" do
    describe "when linked to a track that requires video for submissions" do
      let(:track) { create(:track, video_required_for_submission: true) }
      let(:submission) do
        build(:submission,
          track: track,
          proposal_video_url: nil)
      end

      it "is invalid when no video is provided" do
        expect(submission.valid?).to be_falsy
        expect(submission.errors[:proposal_video_url]).to include("can't be blank")
      end
    end

    describe "when linked to a track that does not require video for submissions" do
      let(:track) { create(:track, video_required_for_submission: false) }
      let(:submission) do
        build(:submission,
          track: track,
          proposal_video_url: nil)
      end

      it "is valid when no video is provided" do
        expect(submission.valid?).to be_truthy
      end
    end

    describe "when not yet linked to a track" do
      let(:submission) do
        build(:submission,
          track: nil)
      end

      it "does not blow up" do
        expect { submission.valid? }.not_to raise_error
      end
    end
  end

  describe "subscribing to e-mail lists" do
    let(:user) { create(:user) }
    let(:track) { create(:track, name: "Test") }
    let(:year) { Date.today.year.to_s }

    it "subscribes after creation" do
      create(:submission,
        submitter: user,
        contact_email: "test@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
    end

    it "subscribes multiple e-mails after creation when separated with commas" do
      create(:submission,
        submitter: user,
        track: track,
        contact_email: "test1@example.com, test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
    end

    it "subscribes multiple e-mails after creation when separated with semicolons" do
      create(:submission,
        submitter: user,
        track: track,
        contact_email: "test1@example.com; test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
    end

    it "subscribes multiple e-mails after creation when separated with spaces" do
      create(:submission,
        submitter: user,
        track: track,
        contact_email: "test1@example.com test2@example.com")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
    end

    it "resubscribes with new data after update" do
      submission = create(:submission,
        submitter: user,
        contact_email: user.email,
        title: "Test",
        description: "Test",
        track: track)
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
      submission.update!(state: "confirmed")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [year])
    end

    it "resubscribes multiple e-mails with new data after update" do
      submission = create(:submission,
        submitter: user,
        contact_email: "test1@example.com, test2@example.com",
        title: "Test",
        description: "Test",
        track: track)
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", submitted_years: [year], confirmed_years: [])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", submitted_years: [year], confirmed_years: [])

      submission.update!(state: "confirmed")
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with(user.email, submitted_years: [year], confirmed_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test1@example.com", submitted_years: [year], confirmed_years: [year])
      expect(ListSubscriptionJob).to have_received(:perform_async)
        .with("test2@example.com", submitted_years: [year], confirmed_years: [year])
    end
  end

  describe "sending e-mails" do
    let(:user) { create(:user, email: "user@example.com") }
    let(:chair) { create(:user) }
    let(:track) { create(:track, chair_ids: [chair.id]) }
    let(:submission) do
      create(:submission,
        submitter: user,
        contact_email: "test1@example.com, test2@example.com",
        coc_acknowledgement: true)
    end

    it "sends and records an acceptance e-mail" do
      submission.send_accept_email!
      expect(submission.sent_notifications.size).to eq(1)
      last_sent_notification = submission.sent_notifications.last
      expect(last_sent_notification.kind).to eq(SentNotification::ACCEPTANCE_KIND)
      expect(last_sent_notification.recipient_email).to eq("test1@example.com, test2@example.com, user@example.com")
    end

    it "sends and records a rejection e-mail" do
      submission.send_reject_email!
      expect(submission.sent_notifications.size).to eq(1)
      last_sent_notification = submission.sent_notifications.last
      expect(last_sent_notification.kind).to eq(SentNotification::REJECTION_KIND)
      expect(last_sent_notification.recipient_email).to eq("test1@example.com, test2@example.com, user@example.com")
    end

    it "sends and records a waitlisting e-mail" do
      submission.send_waitlist_email!
      expect(submission.sent_notifications.size).to eq(1)
      last_sent_notification = submission.sent_notifications.last
      expect(last_sent_notification.kind).to eq(SentNotification::WAITLISTING_KIND)
      expect(last_sent_notification.recipient_email).to eq("test1@example.com, test2@example.com, user@example.com")
    end

    it "sends and records a thanks e-mail" do
      submission.send_thanks_email!
      expect(submission.sent_notifications.size).to eq(1)
      last_sent_notification = submission.sent_notifications.last
      expect(last_sent_notification.kind).to eq(SentNotification::THANKS_KIND)
      expect(last_sent_notification.recipient_email).to eq("test1@example.com, test2@example.com, user@example.com")
    end
  end

  describe "listing public registrants" do
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_other_user) { create(:user) }
    let(:current_registration) { create(:registration, user: current_user) }
    let(:other_registration) { create(:registration, user: other_user) }
    let(:other_other_registration) { create(:registration, user: other_other_user) }
    let(:submission) { create(:submission) }

    it "returns nothing when there are no registrants" do
      expect(submission.public_registrants(current_user)).to be_empty
    end

    it "returns the current user first when there are multiple registrants" do
      submission.user_registrations << other_registration
      submission.user_registrations << current_registration
      expect(submission.public_registrants(current_user)).to eq([current_user, other_user])
    end

    it "returns other users in order of their session registration" do
      travel_to 1.hour.ago do
        submission.user_registrations << other_registration
      end
      submission.user_registrations << other_other_registration
      expect(submission.public_registrants(current_user)).to eq([other_other_user, other_user])
    end

    it "does not return the current user when they have opted out" do
      submission.user_registrations << other_registration
      submission.user_registrations << current_registration
      current_user.update!(show_attendance_publicly: false)
      expect(submission.public_registrants(current_user)).to eq([other_user])
    end

    it "does not return other users when they have opted out" do
      submission.user_registrations << other_registration
      submission.user_registrations << current_registration
      other_user.update!(show_attendance_publicly: false)
      expect(submission.public_registrants(current_user)).to eq([current_user])
    end
  end

  describe "listing tags" do
    let(:submission) { create(:submission) }

    it "is empty by default" do
      expect(submission.tags).to be_empty
    end

    it "includes the cluster as a tag when one is assigned" do
      submission.cluster = create(:cluster, name: "Sports", description: "...")
      expect(submission.tags.size).to eq(1)
      expect(submission.tags["Sports"]).to eq("...")
    end

    it "includes the popular tag when popular? is true" do
      allow(submission).to receive(:popular?).and_return(true)
      expect(submission.tags.size).to eq(1)
      expect(submission.tags["Popular"]).to eq("The event has many more RSVPs than will fit in the venue. Attendees should plan to arrive early to get a seat.")
    end
  end

  describe "finding live/upcoming sessions" do
    let!(:past1) do
      create(:submission,
        year: AnnualSchedule.current.year,
        state: "confirmed",
        start_day: 1,
        start_hour: 9.5,
        end_day: 1,
        end_hour: 10.5)
    end

    let!(:live1) do
      create(:submission,
        year: AnnualSchedule.current.year,
        state: "confirmed",
        start_day: 1,
        start_hour: 9.5,
        end_day: 1,
        end_hour: 11.5)
    end

    let!(:future1) do
      create(:submission,
        year: AnnualSchedule.current.year,
        state: "confirmed",
        start_day: 1,
        start_hour: 12,
        end_day: 1,
        end_hour: 13)
    end

    let!(:future2) do
      create(:submission,
        year: AnnualSchedule.current.year,
        state: "confirmed",
        start_day: 1,
        start_hour: 11,
        end_day: 1,
        end_hour: 12)
    end

    it "allows overriding of the time via an argument" do
      as_of = past1.end_datetime + 5.minutes
      expect(Submission.live(as_of).map(&:id)).to eq([
        live1.id
      ])
    end

    it "allows overriding of the time via an argument" do
      as_of = past1.end_datetime + 5.minutes
      expect(Submission.upcoming(as_of, 3).map(&:id)).to eq([
        future2.id,
        future1.id
      ])
    end
  end
end
