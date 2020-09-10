class UpdateYoutubeLiveStream
  include Sidekiq::Worker

  def perform(youtube_live_stream_id)
    YoutubeLiveStream.find(youtube_live_stream_id).update_on_youtube!
  end
end
