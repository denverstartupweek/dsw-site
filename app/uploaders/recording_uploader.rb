class RecordingUploader < ApplicationUploader
  def fog_public
    false
  end
end
