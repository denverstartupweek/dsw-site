require "rails_helper"

RSpec.describe ZoomJoinUrl, type: :model do
  it { is_expected.to belong_to(:zoom_event) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:url) }
end
