require "rails_helper"

RSpec.describe YoutubeLiveStream, type: :model do
  it { is_expected.to belong_to(:submission) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_inclusion_of(:kind).in_array(YoutubeLiveStream::KINDS) }
end
