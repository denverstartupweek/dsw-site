require "google/apis/youtube_v3"

module HashEquals
  def ==(other)
    to_h == other.to_h
  end
end

Google::Apis::YoutubeV3::LiveStream.send(:include, HashEquals)
Google::Apis::YoutubeV3::LiveBroadcast.send(:include, HashEquals)
