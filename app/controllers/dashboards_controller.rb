class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @submissions = current_user.submissions.includes(:track).for_current_year
    @articles = current_user.articles.includes(:tracks, :publishing)
    @previous_submissions = current_user.submissions.for_previous_years.order("submissions.created_at DESC")
    @venues = current_user.administered_venues
    @my_schedule = Submission
      .for_year(Date.today.year)
      .for_schedule
      .my_schedule(current_user)
      .order(start_day: :asc, start_hour: :asc)
      .includes(:venue,
        :submitter,
        :track,
        :cluster,
        sponsorship: :track)
    @job_fair_signup = current_user.job_fair_signups.for_current_year.accepted.includes(:job_fair_roles).first
  end
end
