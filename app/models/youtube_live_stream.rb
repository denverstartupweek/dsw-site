class YoutubeLiveStream < ApplicationRecord
  TEST_KIND = "test"
  LIVE_KIND = "live"
  KINDS = [
    TEST_KIND,
    LIVE_KIND
  ].freeze

  belongs_to :submission
  validates :kind, presence: true, inclusion: {in: KINDS}

  def live_url
    "https://youtu.be/#{broadcast_id}"
  end

  def title
    full_title = "DSW #{submission.year}: #{ERB::Util.json_escape(submission.title)}"
    suffix = (kind == TEST_KIND ? " - TEST RUN" : "")
    full_title.truncate(100 - suffix.length) + suffix
  end

  def description
    <<~DESC.strip.truncate(10000)
      This event is part of Denver Startup Week #{submission.year}. Register and view the full schedule of events at https://www.denverstartupweek.org/schedule

      #{ERB::Util.json_escape(submission.description)}
    DESC
  end

  def create_on_youtube!
    oauth_service.refresh_if_needed!
    stream = oauth_service.youtube_client.insert_live_stream(
      %w[id snippet cdn status contentDetails],
      google_live_stream
    )
    broadcast = oauth_service.youtube_client.insert_live_broadcast(
      %w[id snippet status contentDetails],
      google_live_broadcast
    )
    oauth_service.youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    update!(
      live_stream_id: stream.id,
      # This can be used at assemble the video URL, per https://stackoverflow.com/questions/31210948/get-current-stream-url-out-of-youtube-live-api
      broadcast_id: broadcast.id,
      ingestion_address: stream.cdn.ingestion_info.ingestion_address,
      backup_ingestion_address: stream.cdn.ingestion_info.backup_ingestion_address,
      rtmps_ingestion_address: stream.cdn.ingestion_info.rtmps_ingestion_address,
      stream_name: stream.cdn.ingestion_info.stream_name
    )
  end

  def update_on_youtube!
    oauth_service.refresh_if_needed!
    stream = oauth_service.youtube_client.update_live_stream(
      %w[id snippet cdn status contentDetails],
      google_live_stream.tap { |s| s.id = live_stream_id }
    )
    broadcast = oauth_service.youtube_client.update_live_broadcast(
      %w[id snippet status contentDetails],
      google_live_broadcast.tap { |b| b.id = broadcast_id }
    )
    oauth_service.youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    update!(
      live_stream_id: stream.id,
      broadcast_id: broadcast.id,
      ingestion_address: stream.cdn.ingestion_info.ingestion_address,
      backup_ingestion_address: stream.cdn.ingestion_info.backup_ingestion_address,
      rtmps_ingestion_address: stream.cdn.ingestion_info.rtmps_ingestion_address,
      stream_name: stream.cdn.ingestion_info.stream_name
    )
  end

  def google_live_stream
    Google::Apis::YoutubeV3::LiveStream.new(
      snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
        title: title,
        description: description
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
  end

  def google_live_broadcast
    Google::Apis::YoutubeV3::LiveBroadcast.new(
      snippet: Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
        scheduled_start_time: (kind == TEST_KIND ? Time.now.iso8601 : submission.start_datetime.iso8601),
        title: title,
        description: description
      ),
      status: Google::Apis::YoutubeV3::LiveBroadcastStatus.new(
        privacy_status: (kind == TEST_KIND ? "unlisted" : "public"),
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
  end

  def oauth_service
    OauthService.for_youtube.first!
  end
end
