module SessionsHelper
  def session_ld_json(submission)
    hash = {
      '@context': "http://schema.org",
      '@type': "Event",
      "eventAttendanceMode": (submission.is_virtual? ? "https://schema.org/OnlineEventAttendanceMode" : "https://schema.org/OfflineEventAttendanceMode"),
      'name': submission.full_title,
      'description': submission.description,
      'startDate': submission.start_datetime.iso8601,
      'endDate': submission.end_datetime.iso8601
    }
    if submission.venue.present?
      hash["location"] = {
        '@type': "Place",
        'name': submission.venue.name,
        'address': {
          '@type': "PostalAddress",
          'streetAddress': submission.venue.address,
          'addressLocality': submission.venue.city,
          'addressRegion': "CO",
          'addressCountry': "US"
        }
      }
    end
    hash.to_json
  end
end
