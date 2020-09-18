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

# Monkeypatch to implement webinar_panelists actions
module Zoom
  module Actions
    module Webinar
      def webinar_panelists_add(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[webinar_id panelists])
        Utils.parse_response self.class.post("/webinars/#{options[:webinar_id]}/panelists", body: options.except(:webinar_id).to_json, headers: request_headers)
      end

      def webinar_panelists_list(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[webinar_id])
        Utils.parse_response self.class.get("/webinars/#{options[:webinar_id]}/panelists", headers: request_headers)
      end
    end
  end
end

# Monkeypatch to implement webinar_details_report action
module Zoom
  module Actions
    module Report
      def webinar_details_report(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id)
        Utils.parse_response self.class.get("/report/webinars/#{params[:id]}", headers: request_headers)
      end
    end
  end
end
