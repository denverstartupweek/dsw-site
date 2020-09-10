# frozen_string_literal: true

require "rails_helper"

RSpec.describe SentNotification, type: :model do
  it { is_expected.to validate_inclusion_of(:kind).in_array(SentNotification::KINDS) }
  it { is_expected.to belong_to(:subject) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:recipient_email) }
end
