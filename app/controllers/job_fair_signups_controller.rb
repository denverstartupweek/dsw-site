class JobFairSignupsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  skip_before_action :store_location, only: %i[new]

  def new
    @signup = JobFairSignup.new
  end

  def create
    @signup = current_user.job_fair_signups.new(job_fair_signup_params)

    if @signup.save
      NotificationsMailer.notify_of_new_job_fair_signup(@signup).deliver_now
      flash[:notice] = "Thanks! We will be in touch shortly."
      redirect_to root_path
    else
      flash[:error] = "We were unable to process your response. Please correct it and try again."
      render action: :new
    end
  end

  def edit
    @signup = current_user.job_fair_signups.find(params[:id])
  end

  def update
    @signup = current_user.job_fair_signups.find(params[:id])
    if @signup.update(job_fair_signup_params)
      flash[:notice] = "Your changes have been saved"
      redirect_to dashboard_path
    else
      flash[:error] = "We were unable to process your response. Please correct it and try again."
      render action: :edit
    end
  end

  private

  def job_fair_signup_params
    params
      .require(:job_fair_signup)
      .permit(
        :company_name,
        :industry_category,
        :organization_size,
        :contact_email,
        :actively_hiring,
        :number_open_positions,
        :number_hiring_next_12_months,
        :covid_impact,
        :notes,
        submission_ids: []
      )
  end
end
