class OauthService < ApplicationRecord
  YOUTUBE_PROVIDER = "youtube"
  ZOOM_PROVIDER = "zoom"
  ZOOM_ADMIN_PROVIDER = "zoom_admin"
  PROVIDERS = [
    YOUTUBE_PROVIDER,
    ZOOM_PROVIDER,
    ZOOM_ADMIN_PROVIDER
  ].freeze

  belongs_to :user
  has_many :submissions, dependent: :restrict_with_error, foreign_key: "zoom_oauth_service_id"
  has_many :zoom_events, dependent: :restrict_with_error

  validates :provider, presence: true, inclusion: {in: PROVIDERS}

  def self.for_youtube
    where(provider: YOUTUBE_PROVIDER)
  end

  def self.for_zoom
    where(provider: ZOOM_PROVIDER)
  end

  def self.find_or_create_from_auth_hash(auth_hash, user)
    record = where(uid: auth_hash["uid"], provider: auth_hash["provider"]).first_or_initialize
    record.user = user
    record.token = auth_hash["credentials"]["token"]
    record.refresh_token = auth_hash["credentials"]["refresh_token"]
    record.token_expires_at = Time.at(auth_hash["credentials"]["expires_at"]).to_datetime
    record.save
  end

  # TODO: Add tests!
  def refresh_if_needed!
    if token_expires_at.past?
      with_lock do
        # Avoid thundering herds - `with_lock` will reload the record, which means
        # it will suddenly be non-expired if another process has refreshed it while
        # we were waiting on the lock
        return unless token_expires_at.past?
        oauth = if provider == YOUTUBE_PROVIDER
          OmniAuth::Strategies::GoogleOauth2.new(
            nil, # App - nil is fine since we're outside of Rack
            ENV["GOOGLE_CLIENT_ID"],
            ENV["GOOGLE_CLIENT_SECRET"],
            scope: "profile,youtube",
            name: "youtube"
          )
        elsif provider == ZOOM_PROVIDER
          OmniAuth::Strategies::Zoom.new(
            nil, # App - nil is fine since we're outside of Rack
            ENV["ZOOM_APP_KEY"],
            ENV["ZOOM_APP_SECRET"]
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

  def zoom_client
    @_zoom_client ||= Zoom::Client::OAuth.new(access_token: token, timeout: 15)
  end

  def youtube_client
    @_youtube_client ||= Google::Apis::YoutubeV3::YouTubeService.new.tap do |service|
      service.authorization = google_secrets.to_authorization
    end
  end

  def google_secrets
    @_google_secrets ||= Google::APIClient::ClientSecrets.new({
      "web" =>
        {
          "access_token" => token,
          "refresh_token" => refresh_token,
          "client_id" => ENV["GOOGLE_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_CLIENT_SECRET"]
        }
    })
  end
end
