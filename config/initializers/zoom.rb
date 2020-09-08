# Override this to get access to newer settings per https://github.com/untitledstartup/zoom_rb/blob/5954cadb513f866c1a3eb1fedd47d9a0f25b2ca4/lib/zoom/actions/webinar.rb
Zoom::Actions::Webinar::SETTINGS_KEYS = %i[panelists_video practice_session hd_video approval_type
  registration_type audio auto_recording enforce_login
  enforce_login_domains alternative_hosts close_registration
  show_share_button allow_multiple_devices registrants_confirmation_email
  meeting_authentication host_video post_webinar_survey survey_url].freeze

# Monkeypatch to fix Zoom::Error ({:base=>"Request Body should be a valid JSON object."})
# Per https://github.com/hintmedia/zoom_rb/issues/25
module Zoom
  module Actions
    module Meeting
      def livestream(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id stream_url stream_key]).permit(%i[page_url])
        Utils.parse_response self.class.patch("/meetings/#{options[:meeting_id]}/livestream", body: options.except(:meeting_id).to_json, headers: request_headers)
      end
    end
  end
end

# Monkeypatch to add a webinar_livestream action
# Based on https://devforum.zoom.us/t/updating-webinar-live-stream-data-via-api/5295/10)
# Nota bene: may not actually work yet
module Zoom
  module Actions
    module Webinar
      def webinar_livestream(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[webinar_id stream_url stream_key]).permit(%i[page_url])
        Utils.parse_response self.class.patch("/webinars/#{options[:webinar_id]}/livestream", body: options.except(:webinar_id).to_json, headers: request_headers)
      end
    end
  end
end
