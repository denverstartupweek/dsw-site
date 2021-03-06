Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], scope: "profile,youtube", name: "youtube"
  provider :zoom, ENV["ZOOM_APP_KEY"], ENV["ZOOM_APP_SECRET"]
  provider :zoom, ENV["ZOOM_ADMIN_APP_KEY"], ENV["ZOOM_ADMIN_APP_SECRET"], name: "zoom_admin"
end
