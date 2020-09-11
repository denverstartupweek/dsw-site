require "rails_helper"
require "zoom_submission_syncer"

describe ZoomSubmissionSyncer do
  let(:zoom_client) do
    instance_double("Zoom::Client")
  end

  let!(:oauth_service) do
    create(:oauth_service,
      provider: OauthService::ZOOM_PROVIDER,
      description: "Zoom Test",
      token_expires_at: 1.hour.from_now)
  end

  before do
    allow_any_instance_of(OauthService).to receive(:zoom_client).and_return(zoom_client)
  end

  describe "when an event is not virtual" do
    let(:submission) do
      create(:submission,
        is_virtual: false)
    end

    before do
      allow(zoom_client).to receive(:meeting_create)
      allow(zoom_client).to receive(:livestream)
    end

    it "does nothing" do
      described_class.new(submission).run!
      expect(zoom_client).not_to have_received(:meeting_create)
      expect(zoom_client).not_to have_received(:livestream)
      expect(submission.zoom_events.count).to eq(0)
    end
  end

  describe "when an event is virtual and uses a standard meeting" do
    let(:submission) do
      create(:submission,
        zoom_oauth_service: oauth_service,
        year: 2020,
        title: "My Awesome Session",
        description: "Some great content.",
        preferred_length: "30 minutes",
        is_virtual: true,
        virtual_meeting_type: Submission::ZOOM_MEETING_TYPE)
    end

    it "creates a meeting and persists the details", freeze_time: true do
      agenda = <<~DESC.strip
        This event is part of Denver Startup Week 2020. Register and view the full schedule of events at https://www.denverstartupweek.org/schedule

        Some great content.
      DESC
      # Test Event
      expect(zoom_client).to receive(:meeting_create).with(
        user_id: "me",
        topic: "DSW 2020: My Awesome Session - TEST RUN",
        type: 2,
        start_time: submission.start_datetime.iso8601,
        duration: 30,
        timezone: "America/Denver",
        agenda: agenda,
        settings: {
          host_video: false,
          participant_video: false,
          join_before_host: false,
          mute_upon_entry: true,
          use_pmi: false,
          approval_type: 2,
          audio: "both",
          auto_recording: "cloud",
          waiting_room: true,
          meeting_authentication: false,
          registrants_confirmation_email: false
        }
      ).and_return({
        "id" => "abc123",
        "join_url" => "https://denverstartupweek.zoom.us/123456",
        "start_url" => "https://denverstartupweek.zoom.us/456789"
      })
      # Live Event
      expect(zoom_client).to receive(:meeting_create).with(
        user_id: "me",
        topic: "DSW 2020: My Awesome Session",
        type: 2,
        start_time: submission.start_datetime.iso8601,
        duration: 30,
        timezone: "America/Denver",
        agenda: agenda,
        settings: {
          host_video: false,
          participant_video: false,
          join_before_host: false,
          mute_upon_entry: true,
          use_pmi: false,
          approval_type: 2,
          audio: "both",
          auto_recording: "cloud",
          waiting_room: true,
          meeting_authentication: false,
          registrants_confirmation_email: false
        }
      ).and_return({
        "id" => "def456",
        "join_url" => "https://denverstartupweek.zoom.us/654321",
        "start_url" => "https://denverstartupweek.zoom.us/987654"
      })
      described_class.new(submission).run!
      expect(submission.zoom_events.size).to eq(2)
      test_event = submission.zoom_events.first
      expect(test_event.kind).to eq(ZoomEvent::TEST_KIND)
      expect(test_event.event_type).to eq(Submission::ZOOM_MEETING_TYPE)
      expect(test_event.zoom_id).to eq("abc123")
      expect(test_event.join_url).to eq("https://denverstartupweek.zoom.us/123456")
      expect(test_event.host_url).to eq("https://denverstartupweek.zoom.us/456789")
      expect(test_event.oauth_service).to eq(oauth_service)

      live_event = submission.zoom_events.last
      expect(live_event.kind).to eq(ZoomEvent::LIVE_KIND)
      expect(live_event.event_type).to eq(Submission::ZOOM_MEETING_TYPE)
      expect(live_event.zoom_id).to eq("def456")
      expect(live_event.join_url).to eq("https://denverstartupweek.zoom.us/654321")
      expect(live_event.host_url).to eq("https://denverstartupweek.zoom.us/987654")
      expect(live_event.oauth_service).to eq(oauth_service)
    end

    describe "when an event also has Youtube streams configured" do
      let!(:test_stream) do
        submission.youtube_live_streams.create!(
          kind: YoutubeLiveStream::TEST_KIND,
          ingestion_address: "rtmp://rtmp.example.com/foo",
          stream_name: "bar"
        )
      end

      let!(:live_stream) do
        submission.youtube_live_streams.create!(
          kind: YoutubeLiveStream::LIVE_KIND,
          ingestion_address: "rtmp://rtmp.example.com/foolive",
          stream_name: "barlive"
        )
      end

      before do
        submission.update!(broadcast_on_youtube_live: true)
      end

      it "wires up livestreaming settings to Youtube" do
        # Test Event
        expect(zoom_client).to receive(:meeting_create).with(hash_including(
          topic: "DSW 2020: My Awesome Session - TEST RUN"
        )).and_return({
          "id" => "abc123",
          "join_url" => "https://denverstartupweek.zoom.us/123456",
          "start_url" => "https://denverstartupweek.zoom.us/456789"
        })
        # Live Event
        expect(zoom_client).to receive(:meeting_create).with(
          hash_including(topic: "DSW 2020: My Awesome Session")
        ).and_return({
          "id" => "def456",
          "join_url" => "https://denverstartupweek.zoom.us/654321",
          "start_url" => "https://denverstartupweek.zoom.us/987654"
        })
        expect(zoom_client).to receive(:livestream).with(
          meeting_id: "abc123",
          stream_url: "rtmp://rtmp.example.com/foo",
          stream_key: "bar"
        )
        expect(zoom_client).to receive(:livestream).with(
          meeting_id: "def456",
          stream_url: "rtmp://rtmp.example.com/foolive",
          stream_key: "barlive"
        )
        described_class.new(submission).run!
      end
    end
  end

  describe "when an event is virtual and uses a webinar" do
    let(:submission) do
      create(:submission,
        zoom_oauth_service: oauth_service,
        year: 2020,
        title: "My Awesome Session",
        description: "Some great content.",
        preferred_length: "30 minutes",
        is_virtual: true,
        virtual_meeting_type: Submission::ZOOM_WEBINAR_TYPE)
    end

    it "creates a webinar and persists the details", freeze_time: true do
      agenda = <<~DESC.strip
        This event is part of Denver Startup Week 2020. Register and view the full schedule of events at https://www.denverstartupweek.org/schedule

        Some great content.
      DESC
      # Test Event
      expect(zoom_client).to receive(:webinar_create).with(
        host_id: "me",
        topic: "DSW 2020: My Awesome Session - TEST RUN",
        type: 5,
        start_time: submission.start_datetime.iso8601,
        duration: 30,
        timezone: "America/Denver",
        agenda: agenda,
        settings: {
          host_video: false,
          panelists_video: true,
          hd_video: true,
          approval_type: 2,
          audio: "both",
          auto_recording: "cloud",
          allow_multiple_devices: true,
          registrants_confirmation_email: false,
          meeting_authentication: false,
          post_webinar_survey: true,
          survey_url: "http://denver-startup-week.dev/schedule/#{submission.id}-my-awesome-session"
        }
      ).and_return({
        "id" => "abc123",
        "join_url" => "https://denverstartupweek.zoom.us/123456",
        "start_url" => "https://denverstartupweek.zoom.us/456789"
      })
      # Live Event
      expect(zoom_client).to receive(:webinar_create).with(
        host_id: "me",
        topic: "DSW 2020: My Awesome Session",
        type: 5,
        start_time: submission.start_datetime.iso8601,
        duration: 30,
        timezone: "America/Denver",
        agenda: agenda,
        settings: {
          host_video: false,
          panelists_video: true,
          hd_video: true,
          approval_type: 2,
          audio: "both",
          auto_recording: "cloud",
          allow_multiple_devices: true,
          registrants_confirmation_email: false,
          meeting_authentication: false,
          post_webinar_survey: true,
          survey_url: "http://denver-startup-week.dev/schedule/#{submission.id}-my-awesome-session"
        }
      ).and_return({
        "id" => "def456",
        "join_url" => "https://denverstartupweek.zoom.us/654321",
        "start_url" => "https://denverstartupweek.zoom.us/987654"
      })
      described_class.new(submission).run!
      expect(submission.zoom_events.size).to eq(2)
      test_event = submission.zoom_events.first
      expect(test_event.kind).to eq(ZoomEvent::TEST_KIND)
      expect(test_event.event_type).to eq(Submission::ZOOM_WEBINAR_TYPE)
      expect(test_event.zoom_id).to eq("abc123")
      expect(test_event.join_url).to eq("https://denverstartupweek.zoom.us/123456")
      expect(test_event.host_url).to eq("https://denverstartupweek.zoom.us/456789")
      expect(test_event.oauth_service).to eq(oauth_service)

      live_event = submission.zoom_events.last
      expect(live_event.kind).to eq(ZoomEvent::LIVE_KIND)
      expect(live_event.event_type).to eq(Submission::ZOOM_WEBINAR_TYPE)
      expect(live_event.zoom_id).to eq("def456")
      expect(live_event.join_url).to eq("https://denverstartupweek.zoom.us/654321")
      expect(live_event.host_url).to eq("https://denverstartupweek.zoom.us/987654")
      expect(live_event.oauth_service).to eq(oauth_service)
    end

    describe "when an event also has Youtube streams configured" do
      let!(:test_stream) do
        submission.youtube_live_streams.create!(
          kind: YoutubeLiveStream::TEST_KIND,
          ingestion_address: "rtmp://rtmp.example.com/foo",
          stream_name: "bar"
        )
      end

      let!(:live_stream) do
        submission.youtube_live_streams.create!(
          kind: YoutubeLiveStream::LIVE_KIND,
          ingestion_address: "rtmp://rtmp.example.com/foolive",
          stream_name: "barlive"
        )
      end

      before do
        submission.update!(broadcast_on_youtube_live: true)
      end

      it "wires up livestreaming settings to Youtube" do
        # Test Event
        expect(zoom_client).to receive(:webinar_create).with(hash_including(
          topic: "DSW 2020: My Awesome Session - TEST RUN"
        )).and_return({
          "id" => "abc123",
          "join_url" => "https://denverstartupweek.zoom.us/123456",
          "start_url" => "https://denverstartupweek.zoom.us/456789"
        })
        # Live Event
        expect(zoom_client).to receive(:webinar_create).with(
          hash_including(topic: "DSW 2020: My Awesome Session")
        ).and_return({
          "id" => "def456",
          "join_url" => "https://denverstartupweek.zoom.us/654321",
          "start_url" => "https://denverstartupweek.zoom.us/987654"
        })
        described_class.new(submission).run!
      end
    end
  end
end
