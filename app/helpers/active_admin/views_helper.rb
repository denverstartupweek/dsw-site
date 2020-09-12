module ActiveAdmin
  module ViewsHelper
    def collection_for_hour_select
      (0..96).map do |i|
        [
          (Time.now.at_beginning_of_day + (i.to_f / 4).hours).strftime("%l:%M%P"),
          (i.to_f / 4)
        ]
      end
    end

    def status_for_submission(submission)
      if submission.confirmed? || submission.venue_confirmed?
        :ok
      elsif submission.rejected? || submission.withdrawn?
        :error
      else
        :warning
      end
    end

    def status_for_job_fair_signup(job_fair_signup)
      if job_fair_signup.accepted?
        :ok
      elsif job_fair_signup.rejected?
        :error
      else
        :warning
      end
    end

    def status_for_rating(rating)
      if rating <= 2
        :error
      elsif rating <= 4
        :warning
      else
        :ok
      end
    end
  end
end
