require "google/apis/youtube_v3"

class CreateOrUpdateYoutubeLiveJob
  include Sidekiq::Worker

  TEST_STREAM_NAME = "Test Stream"
  LIVE_STREAM_NAME = "Live Stream"

  def perform(submission_id)
    submission = Submission.find(submission_id)

    # TODO: Handle checking for token validity and refreshing it if needed
    oauth_service.refresh_if_needed!

    # TODO: handle removing streams when this is toggled off
    return unless submission.broadcast_on_youtube_live?

    if submission.youtube_live_streams.any?
      # Can really only update title/description/time (which should be totally fine)
      # update_test_stream(submission)
      # update_live_stream(submission)
    else
      create_test_stream(submission) unless test_stream_exists?(submission)
      create_live_stream(submission) unless live_stream_exists?(submission)
    end
  end

  private

  def title_for(submission, suffix = nil)
    title = "DSW #{Date.today.year}: #{submission.title}"
    suffix_with_separator = if suffix
      " - #{suffix}"
    else
      ""
    end
    title.truncate(128 - suffix_with_separator.length) + suffix_with_separator
  end

  def description_for(submission)
    <<-DESC.truncate(10000)
    Register and view the full schedule of events at denverstartupweek.org/schedule

    #{submission.description}
    DESC
  end

  def create_test_stream(submission)
    stream = youtube_client.insert_live_stream(
      %w[id snippet cdn status contentDetails],
      Google::Apis::YoutubeV3::LiveStream.new(
        snippet: {
          title: title_for(submission, "TEST RUN"),
          description: description_for(submission)
        },
        cdn: {
          frameRate: "variable",
          resolution: "variable",
          ingestionType: "rtmp"
        },
        contentDetails: {
          isReusable: false
        }
      )
    )
    broadcast = youtube_client.insert_live_broadcast(
      %w[id snippet status contentDetails],
      Google::Apis::YoutubeV3::LiveBroadcast.new(
        snippet: {
          scheduledStartTime: Time.now.iso8601,
          title: title_for(submission),
          description: description_for(submission)
        },
        status: {
          privacyStatus: "unlisted",
          madeForKids: false
        },
        contentDetails: {
          enableAutoStart: true,
          enableAutoStop: true,
          enableDvr: true,
          enableEmbed: true,
          recordFromStart: true
        }
      )
    )
    youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    save_live_stream(TEST_STREAM_NAME, submission, stream, broadcast)
  end

  def create_live_stream(submission)
    stream = youtube_client.insert_live_stream(
      %w[id snippet cdn status contentDetails],
      Google::Apis::YoutubeV3::LiveStream.new(
        snippet: {
          title: title_for(submission),
          description: description_for(submission)
        },
        cdn: {
          frameRate: "variable",
          resolution: "variable",
          ingestionType: "rtmp"
        },
        contentDetails: {
          isReusable: false
        }
      )
    )
    broadcast = youtube_client.insert_live_broadcast(
      %w[id snippet status contentDetails],
      Google::Apis::YoutubeV3::LiveBroadcast.new(
        snippet: {
          scheduledStartTime: submission.start_datetime.iso8601,
          title: title_for(submission),
          description: description_for(submission)
        },
        status: {
          privacyStatus: "public",
          madeForKids: false
        },
        contentDetails: {
          enableAutoStart: true,
          enableAutoStop: true,
          enableDvr: true,
          enableEmbed: true,
          recordFromStart: true
        }
      )
    )
    youtube_client.bind_live_broadcast(broadcast.id, %w[id], stream_id: stream.id)
    save_live_stream(LIVE_STREAM_NAME, submission, stream, broadcast)
  end

  def save_live_stream(name, submission, stream, broadcast)
    submission.youtube_live_streams.create!(
      name: name,
      stream_id: stream.id,
      # This can be used at assemble the video URL, per https://stackoverflow.com/questions/31210948/get-current-stream-url-out-of-youtube-live-api
      broadcast_id: broadcast.id,
      ingestion_address: stream.cdn.ingestion_info.ingestion_address,
      backup_ingestion_address: stream.cdn.ingestion_info.backup_ingestion_address,
      rtmps_ingestion_address: stream.cdn.ingestion_info.rtmps_ingestion_address,
      stream_name: stream.cdn.ingestion_info.stream_name
    )
  end

  def test_stream_exists?(submission)
    submission.youtube_live_streams.where(name: TEST_STREAM_NAME).any?
  end

  def live_stream_exists?(submission)
    submission.youtube_live_streams.where(name: LIVE_STREAM_NAME).any?
  end

  def oauth_service
    @_oauth_service ||= OauthService.for_youtube.first!
  end

  def secrets
    @_secrets ||= Google::APIClient::ClientSecrets.new({
      "web" =>
        {
          "access_token" => oauth_service.access_token,
          "refresh_token" => oauth_service.refresh_token,
          "client_id" => ENV["GOOGLE_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_CLIENT_SECRET"]
        }
    })
  end

  def youtube_client
    @_youtube_client ||= Google::Apis::YoutubeV3::YouTubeService.new.tap do |service|
      service.authorization = secrets.to_authorization
    end
  end
end
