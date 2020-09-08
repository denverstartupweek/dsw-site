# Override this to get access to newer settings per https://github.com/untitledstartup/zoom_rb/blob/5954cadb513f866c1a3eb1fedd47d9a0f25b2ca4/lib/zoom/actions/webinar.rb
Zoom::Actions::Webinar::SETTINGS_KEYS = %i[panelists_video practice_session hd_video approval_type
  registration_type audio auto_recording enforce_login
  enforce_login_domains alternative_hosts close_registration
  show_share_button allow_multiple_devices registrants_confirmation_email
  meeting_authentication host_video post_webinar_survey survey_url].freeze
