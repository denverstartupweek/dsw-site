module SubmissionsHelper
  def time_and_location(submission)
    text = if submission.day
      [submission.day, submission.time_range.try(:downcase)].compact * " "
    else
      submission.time_range.try(:titleize)
    end
    if text.present? && submission.location.present?
      text += " at #{submission.location}"
    elsif submission.location.present?
      text = "At #{submission.location}"
    end
    text
  end

  def approximate(number, round_to = 100)
    round_to = 10 if number <= 100
    approximation = (number / round_to).ceil * round_to
    approximation > 0 ? "About #{approximation}" : ""
  end

  def as_of
    if params[:as_of].nil?
      Time.now.in_time_zone("America/Denver")
    elsif params[:as_of].is_a?(String)
      DateTime.parse(params[:as_of])
    end
  end

  def live?(submission, lead_by = 5)
    now = as_of
    now_hour = now.hour + ((now.min + lead_by).to_f / 60)
    submission.start_hour < now_hour &&
      submission.end_hour >= now_hour
  end
end
