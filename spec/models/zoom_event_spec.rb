require "rails_helper"

RSpec.describe ZoomEvent, type: :model do
  it { is_expected.to belong_to(:submission) }
  it { is_expected.to belong_to(:oauth_service) }
  it { is_expected.to have_many(:zoom_join_urls).dependent(:destroy) }
  it { is_expected.to have_many(:zoom_recordings).dependent(:restrict_with_error) }
  it { is_expected.to validate_presence_of(:zoom_id) }
  it { is_expected.to validate_presence_of(:event_type) }
  it { is_expected.to validate_inclusion_of(:event_type).in_array(ZoomEvent::EVENT_TYPES) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_inclusion_of(:kind).in_array(ZoomEvent::KINDS) }

  describe "fetching reporting data", freeze_time: true do
    before do
      allow_any_instance_of(OauthService).to receive(:refresh_if_needed!)
    end

    let(:zoom_client) do
      instance_double("Zoom::Client")
    end

    let!(:oauth_service) do
      create(:oauth_service, provider: OauthService::ZOOM_ADMIN_PROVIDER)
    end

    describe "given a webinar" do
      let(:event) do
        create(:zoom_event, event_type: Submission::ZOOM_WEBINAR_TYPE)
      end
      it "populates the relevant fields" do
        allow_any_instance_of(OauthService).to receive(:zoom_client).and_return(zoom_client)
        expect(zoom_client).to receive(:webinar_details_report).with(id: event.zoom_id).and_return({
          "duration" => 76,
          "total_minutes" => 1280,
          "participants_count" => 31,
          "start_time" => "2020-09-18T17:45:21Z",
          "end_time" => "2020-09-18T19:01:21Z"
        })

        event.fetch_reporting_data!

        expect(event.report_fetched_at).to eq(DateTime.now)
        expect(event.duration).to eq(76)
        expect(event.total_minutes).to eq(1280)
        expect(event.participants_count).to eq(31)
        expect(event.actual_start_time).to eq(DateTime.parse("2020-09-18 17:45:21"))
        expect(event.actual_end_time).to eq(DateTime.parse("2020-09-18 19:01:21"))
      end
    end

    describe "given a meeting" do
      let(:event) do
        create(:zoom_event, event_type: Submission::ZOOM_MEETING_TYPE)
      end
      it "populates the relevant fields" do
        allow_any_instance_of(OauthService).to receive(:zoom_client).and_return(zoom_client)
        expect(zoom_client).to receive(:meeting_details_report).with(id: event.zoom_id).and_return({
          "duration" => 76,
          "total_minutes" => 1280,
          "participants_count" => 31,
          "start_time" => "2020-09-18T17:45:21Z",
          "end_time" => "2020-09-18T19:01:21Z"
        })

        event.fetch_reporting_data!

        expect(event.report_fetched_at).to eq(DateTime.now)
        expect(event.duration).to eq(76)
        expect(event.total_minutes).to eq(1280)
        expect(event.participants_count).to eq(31)
        expect(event.actual_start_time).to eq(DateTime.parse("2020-09-18 17:45:21"))
        expect(event.actual_end_time).to eq(DateTime.parse("2020-09-18 19:01:21"))
      end
    end
  end
end
