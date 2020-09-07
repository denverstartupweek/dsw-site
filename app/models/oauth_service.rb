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

  def refresh_if_needed!
    if token_expires_at.past?
      with_lock "ACCESS EXCLUSIVE" do
        # Avoid thundering herds - `with_lock` will reload the record, which means
        # it will suddenly be non-expired if another process has refreshed it while
        # we were waiting on the lock
        return unless token_expires_at.past?
        oauth = if provider.youtube?
          OmniAuth::Strategies::GoogleOauth2.new(
            nil, # App - nil is fine since we're outside of Rack
            ENV["GOOGLE_CLIENT_ID"],
            ENV["GOOGLE_CLIENT_SECRET"],
            "profile,youtube",
            name: "youtube"
          )
        end
        token = OAuth2::AccessToken.new(
          oauth.client,
          token,
          {refresh_token: refresh_token}
        )
        new_token = token.refresh!
        if new_token.present?
          update!(
            token: new_token.token,
            refresh_token: new_token.refresh_token,
            token_expires_at: Time.at(new_token.expires_at).to_datetime
          )
        end
      end
    end
  end
end
