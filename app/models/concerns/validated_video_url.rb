module ValidatedVideoUrl
  extend ActiveSupport::Concern

  YOUTUBE_REGEX = %r{\A(?:http://|https://)?youtu.be/(\S+)\z}
  VIMEO_REGEX = %r{\A(?:http://|https://)?vimeo.com/(\d+)\z}

  included do
    validates :video_url,
      format: {with: Regexp.union(YOUTUBE_REGEX, VIMEO_REGEX), allow_blank: true}
  end

  def embed_video_url(extra_params = {modestbranding: 1, showinfo: 0})
    if (result = YOUTUBE_REGEX.match(video_url))
      "https://www.youtube.com/embed/#{result[1]}?#{extra_params.to_query}"
    elsif (result = VIMEO_REGEX.match(video_url))
      "https://player.vimeo.com/video/#{result[1]}"
    end
  end
end
