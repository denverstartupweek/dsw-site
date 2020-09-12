require "google/apis/youtube_v3"
require "google/api_client/client_secrets"

class YoutubeLiveSubmissionSyncer
  def initialize(submission)
    @submission = submission
  end

  def run!
    # TODO: handle removing streams when this is toggled off
    return unless @submission.broadcast_on_youtube_live?

    Rails.logger.info "Creating streams..."
    # create_test_stream(@submission) unless test_stream_exists?(@submission)
    create_live_stream(@submission) unless live_stream_exists?(@submission)
  end

  private

  def create_test_stream(submission)
    Rails.logger.info "Creating test stream..."
    stream = submission.youtube_live_streams.build(
      kind: YoutubeLiveStream::TEST_KIND
    )
    stream.create_on_youtube!
  end

  def create_live_stream(submission)
    Rails.logger.info "Creating live stream..."
    stream = submission.youtube_live_streams.build(
      kind: YoutubeLiveStream::LIVE_KIND
    )
    stream.create_on_youtube!
  end

  def test_stream_exists?(submission)
    submission.youtube_live_streams.where(kind: YoutubeLiveStream::TEST_KIND).any?
  end

  def live_stream_exists?(submission)
    submission.youtube_live_streams.where(kind: YoutubeLiveStream::LIVE_KIND).any?
  end
end
