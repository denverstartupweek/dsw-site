class ZoomRecording < ApplicationRecord
  belongs_to :zoom_event

  mount_uploader :file, RecordingUploader
end
