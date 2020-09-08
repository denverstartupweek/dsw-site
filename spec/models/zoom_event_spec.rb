require "rails_helper"

RSpec.describe ZoomEvent, type: :model do
  it { is_expected.to belong_to(:submission) }
  it { is_expected.to belong_to(:oauth_service) }
  it { is_expected.to validate_presence_of(:zoom_id) }
  it { is_expected.to validate_presence_of(:event_type) }
  it { is_expected.to validate_inclusion_of(:event_type).in_array(ZoomEvent::EVENT_TYPES) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_inclusion_of(:kind).in_array(ZoomEvent::KINDS) }
end
