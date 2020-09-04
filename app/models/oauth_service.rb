class OauthService < ApplicationRecord
  PROVIDERS = %w[zoom youtube]

  belongs_to :user

  validates :provider, presence: true, inclusion: {in: PROVIDERS}

  def self.find_or_create_from_auth_hash(auth_hash, user)
    record = where(uid: auth_hash["uid"], provider: auth_hash["provider"]).first_or_initialize
    record.user = user
    record.token = auth_hash["credentials"]["token"]
    record.refresh_token = auth_hash["credentials"]["refresh_token"]
    record.token_expires_at = Time.at(auth_hash["credentials"]["expires_at"]).to_datetime
    record.save
  end
end
