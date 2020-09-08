require "rails_helper"
require "youtube_live_submission_syncer"

describe YoutubeLiveSubmissionSyncer do
  let(:youtube_client) do
    instance_double("Google::Apis::YoutubeV3::YoutubeService")
  end

  let!(:oauth_service) do
    create(:oauth_service,
      provider: OauthService::YOUTUBE_PROVIDER,
      description: "Youtube Test",
      token_expires_at: 1.hour.from_now)
  end

  before do
    allow_any_instance_of(YoutubeLiveSubmissionSyncer).to receive(:youtube_client).and_return(youtube_client)
  end

  describe "when youtube live broadcasting is turned off" do
    let(:submission) do
      create(:submission,
        broadcast_on_youtube_live: false)
    end

    before do
      allow(youtube_client).to receive(:insert_live_stream)
      allow(youtube_client).to receive(:insert_live_broadcast)
      allow(youtube_client).to receive(:bind_live_broadcast)
    end

    it "does nothing" do
      described_class.new(submission).run!
      expect(youtube_client).not_to have_received(:insert_live_stream)
      expect(youtube_client).not_to have_received(:insert_live_broadcast)
      expect(youtube_client).not_to have_received(:bind_live_broadcast)
      expect(submission.youtube_live_streams.count).to eq(0)
    end
  end

  describe "when youtube live broadcasting is turned on" do
    let(:submission) {
      create(:submission,
        title: "My Cool Talk",
        description: "Neat!",
        broadcast_on_youtube_live: true)
    }

    describe "when no live streams have been created yet" do
      it "creates new streams and persists them", freeze_time: true do
        # Creating Test Stream
        expect(youtube_client).to receive(:insert_live_stream).ordered.with(
          %w[id snippet cdn status contentDetails],
          Google::Apis::YoutubeV3::LiveStream.new(
            snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
              title: "DSW 2020: My Cool Talk - TEST RUN",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            cdn: Google::Apis::YoutubeV3::CdnSettings.new(
              frame_rate: "variable",
              resolution: "variable",
              ingestion_type: "rtmp"
            ),
            content_details: Google::Apis::YoutubeV3::LiveStreamContentDetails.new(
              is_reusable: false
            )
          )
        ).and_return(
          Google::Apis::YoutubeV3::LiveStream.new(
            id: "abc123",
            snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
              title: "DSW 2020: My Cool Talk - TEST RUN",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            cdn: Google::Apis::YoutubeV3::CdnSettings.new(
              ingestion_info: Google::Apis::YoutubeV3::IngestionInfo.new(
                stream_name: "foo",
                ingestion_address: "rtmp://rtmp.example.com/foo",
                backup_ingestion_address: "rtmp://rtmp.example.com/foobackup",
                rtmps_ingestion_address: "rtmps://rtmp.example.com/foo",
                rtmps_backup_ingestion_address: "rtmps://rtmp.example.com/foobackup"
              )
            )
          )
        )
        # Creating Test Broadcast
        expect(youtube_client).to receive(:insert_live_broadcast).ordered.with(
          %w[id snippet status contentDetails],
          Google::Apis::YoutubeV3::LiveBroadcast.new(
            snippet: Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
              scheduled_start_time: Time.now.iso8601,
              title: "DSW 2020: My Cool Talk - TEST RUN",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            status: Google::Apis::YoutubeV3::LiveBroadcastStatus.new(
              privacy_status: "unlisted",
              self_declared_made_for_kids: false
            ),
            content_details: Google::Apis::YoutubeV3::LiveBroadcastContentDetails.new(
              enable_auto_start: true,
              enable_auto_stop: true,
              enable_dvr: true,
              enable_embed: true,
              record_from_start: true
            )
          )
        ).and_return(
          Google::Apis::YoutubeV3::LiveBroadcast.new(id: "def456")
        )

        # Creating Live Stream
        expect(youtube_client).to receive(:insert_live_stream).ordered.with(
          %w[id snippet cdn status contentDetails],
          Google::Apis::YoutubeV3::LiveStream.new(
            snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
              title: "DSW 2020: My Cool Talk",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            cdn: Google::Apis::YoutubeV3::CdnSettings.new(
              frame_rate: "variable",
              resolution: "variable",
              ingestion_type: "rtmp"
            ),
            content_details: Google::Apis::YoutubeV3::LiveStreamContentDetails.new(
              is_reusable: false
            )
          )
        ).and_return(
          Google::Apis::YoutubeV3::LiveStream.new(
            id: "ghi789",
            snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
              title: "DSW 2020: My Cool Talk",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            cdn: Google::Apis::YoutubeV3::CdnSettings.new(
              ingestion_info: Google::Apis::YoutubeV3::IngestionInfo.new(
                stream_name: "foolive",
                ingestion_address: "rtmp://rtmp.example.com/foolive",
                backup_ingestion_address: "rtmp://rtmp.example.com/foolivebackup",
                rtmps_ingestion_address: "rtmps://rtmp.example.com/foolive",
                rtmps_backup_ingestion_address: "rtmps://rtmp.example.com/foolivebackup"
              )
            )
          )
        )
        # Creating Live Broadcast
        expect(youtube_client).to receive(:insert_live_broadcast).ordered.with(
          %w[id snippet status contentDetails],
          Google::Apis::YoutubeV3::LiveBroadcast.new(
            snippet: Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
              scheduled_start_time: submission.start_datetime.iso8601,
              title: "DSW 2020: My Cool Talk",
              description: <<~DESC.strip
                Register and view the full schedule of events at denverstartupweek.org/schedule

                Neat!
              DESC
            ),
            status: Google::Apis::YoutubeV3::LiveBroadcastStatus.new(
              privacy_status: "public",
              self_declared_made_for_kids: false
            ),
            content_details: Google::Apis::YoutubeV3::LiveBroadcastContentDetails.new(
              enable_auto_start: true,
              enable_auto_stop: true,
              enable_dvr: true,
              enable_embed: true,
              record_from_start: true
            )
          )
        ).and_return(
          Google::Apis::YoutubeV3::LiveBroadcast.new(id: "jkl012")
        )
        expect(youtube_client).to receive(:bind_live_broadcast).with("def456", %w[id], stream_id: "abc123")
        expect(youtube_client).to receive(:bind_live_broadcast).with("jkl012", %w[id], stream_id: "ghi789")

        described_class.new(submission).run!

        expect(submission.youtube_live_streams.count).to eq(2)
        test_stream = submission.youtube_live_streams.first
        expect(test_stream.name).to eq("Test Stream")
        expect(test_stream.live_stream_id).to eq("abc123")
        expect(test_stream.broadcast_id).to eq("def456")
        expect(test_stream.stream_name).to eq("foo")
        expect(test_stream.ingestion_address).to eq("rtmp://rtmp.example.com/foo")
        expect(test_stream.backup_ingestion_address).to eq("rtmp://rtmp.example.com/foobackup")
        expect(test_stream.rtmps_ingestion_address).to eq("rtmps://rtmp.example.com/foo")

        live_stream = submission.youtube_live_streams.last
        expect(live_stream.name).to eq("Live Stream")
      end
    end
  end
end
