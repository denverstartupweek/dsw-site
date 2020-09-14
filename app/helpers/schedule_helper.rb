module ScheduleHelper
  def formatted_start_date_for_index(index, year, format = "%B %-d")
    (AnnualSchedule.find_by!(year: year).week_start_at + index - 2).strftime(format)
  end

  def registered_for_session?(submission)
    registered? && current_registration.submission_ids.include?(submission.id)
  end

  def ratings_for_select
    Feedback::RATINGS.invert
  end

  def in_or_post_week?
    AnnualSchedule.in_week? || AnnualSchedule.post_week?
  end

  def as_of
    if params[:as_of].nil?
      Time.now.in_time_zone("America/Denver")
    elsif params[:as_of].is_a?(String)
      DateTime.parse(params[:as_of])
    end
  end

  def live_sessions
    Submission.live(as_of).includes(:track)
  end

  def upcoming_sessions(limit)
    Submission.upcoming(as_of, limit).includes(:track)
  end

  def live?(submission, lead_by = 5)
    now = as_of
    now_hour = now.hour + ((now.min + lead_by).to_f / 60)
    submission.start_hour < now_hour &&
      submission.end_hour >= now_hour
  end
end
