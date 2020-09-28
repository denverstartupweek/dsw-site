class RecordingUploader < ApplicationUploader
  def fog_public
    false
  end

  def extension_whitelist
    %w[mp4 m4a txt vtt json html]
  end
end
