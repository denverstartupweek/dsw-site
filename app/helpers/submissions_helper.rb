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
end
