require "rails_helper"

RSpec.describe ZoomRecording, type: :model do
  it { is_expected.to belong_to(:zoom_event) }
end
