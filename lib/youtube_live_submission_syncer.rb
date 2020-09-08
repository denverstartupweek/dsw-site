require "google/apis/youtube_v3"
require "google/api_client/client_secrets"

class YoutubeLiveSubmissionSyncer
  def initialize(submission)
    @submission = submission
  end

  def run!
    Rails.logger.info "Checking service to see if a token refresh is needed..."
    youtube_oauth_service.refresh_if_needed!

    # TODO: handle removing streams when this is toggled off
    return unless @submission.broadcast_on_youtube_live?

    if @submission.youtube_live_streams.any?
      # Can really only update title/description/time (which should be totally fine)
      # update_test_stream(submission)
      # update_live_stream(submission)
    else
      Rails.logger.info "Creating streams..."
      create_test_stream(@submission) unless test_stream_exists?(@submission)
      create_live_stream(@submission) unless live_stream_exists?(@submission)
    end
  end

  # Public for test stubbing
  def youtube_client
    @_youtube_client ||= Google::Apis::YoutubeV3::YouTubeService.new.tap do |service|
      service.authorization = google_secrets.to_authorization
    end
  end

  private

  def title_for(submission, suffix = nil)
    title = "DSW #{submission.year}: #{ERB::Util.json_escape(submission.title)}"
    suffix_with_separator = if suffix
      " - #{suffix}"
    else
      ""
    end
    title.truncate(128 - suffix_with_separator.length) + suffix_with_separator
  end

  def description_for(submission)
    <<~DESC.strip.truncate(10000)
      Register and view the full schedule of events at denverstartupweek.org/schedule

      #{submission.description}
    DESC
  end

  def create_test_stream(submission)
    Rails.logger.info "Creating test stream..."
    stream = youtube_client.insert_live_stream(
      %w[id snippet cdn status contentDetails],
      Google::Apis::YoutubeV3::LiveStream.new(
        snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
          title: title_for(submission, "TEST RUN"),
          description: description_for(submission)
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
    )
    broadcast = youtube_client.insert_live_broadcast(
      %w[id snippet status contentDetails],
      Google::Apis::YoutubeV3::LiveBroadcast.new(
        snippet: Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
          scheduled_start_time: Time.now.iso8601,
          title: title_for(submission, "TEST RUN"),
          description: description_for(submission)
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
    )
    youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    save_live_stream(submission, stream, broadcast, YoutubeLiveStream::TEST_KIND)
  end

  def create_live_stream(submission)
    Rails.logger.info "Creating live stream..."
    stream = youtube_client.insert_live_stream(
      %w[id snippet cdn status contentDetails],
      Google::Apis::YoutubeV3::LiveStream.new(
        snippet: Google::Apis::YoutubeV3::LiveStreamSnippet.new(
          title: title_for(submission),
          description: description_for(submission)
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
    )
    broadcast = youtube_client.insert_live_broadcast(
      %w[id snippet status contentDetails],
      Google::Apis::YoutubeV3::LiveBroadcast.new(
        snippet: Google::Apis::YoutubeV3::LiveBroadcastSnippet.new(
          scheduled_start_time: submission.start_datetime.iso8601,
          title: title_for(submission),
          description: description_for(submission)
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
    )
    youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    save_live_stream(submission, stream, broadcast, YoutubeLiveStream::LIVE_KIND)
  end

  def save_live_stream(submission, stream, broadcast, kind)
    submission.youtube_live_streams.create!(
      kind: kind,
      live_stream_id: stream.id,
      # This can be used at assemble the video URL, per https://stackoverflow.com/questions/31210948/get-current-stream-url-out-of-youtube-live-api
      broadcast_id: broadcast.id,
      ingestion_address: stream.cdn.ingestion_info.ingestion_address,
      backup_ingestion_address: stream.cdn.ingestion_info.backup_ingestion_address,
      rtmps_ingestion_address: stream.cdn.ingestion_info.rtmps_ingestion_address,
      stream_name: stream.cdn.ingestion_info.stream_name
    )
  end

  def test_stream_exists?(submission)
    submission.youtube_live_streams.where(kind: YoutubeLiveStream::TEST_KIND).any?
  end

  def live_stream_exists?(submission)
    submission.youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).any?
  end

  def youtube_oauth_service
    @_youtube_oauth_service ||= OauthService.for_youtube.first!
  end

  def google_secrets
    @_google_secrets ||= Google::APIClient::ClientSecrets.new({
      "web" =>
        {
          "access_token" => youtube_oauth_service.token,
          "refresh_token" => youtube_oauth_service.refresh_token,
          "client_id" => ENV["GOOGLE_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_CLIENT_SECRET"]
        }
    })
  end
end
