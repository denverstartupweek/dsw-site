class ZoomJoinUrl < ApplicationRecord
  belongs_to :zoom_event
  belongs_to :user

  validates :url, presence: true
end
