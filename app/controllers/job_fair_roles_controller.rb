class JobFairRolesController < ApplicationController
  before_action :authenticate_user!

  def new
    @job_fair_signup = job_fair_signup
    @job_fair_role = @job_fair_signup.job_fair_roles.build
  end

  def create
    @job_fair_signup = job_fair_signup
    @job_fair_role = @job_fair_signup.job_fair_roles.build(job_fair_role_params)

    if @job_fair_role.save
      flash[:notice] = "Role saved!"
      redirect_to dashboard_path
    else
      flash[:error] = "We were unable to process your response. Please correct it and try again."
      render action: :new
    end
  end

  def edit
    @job_fair_signup = job_fair_signup
    @job_fair_role = @job_fair_signup.job_fair_roles.find(params[:id])
  end

  def update
    @job_fair_signup = job_fair_signup
    @job_fair_role = @job_fair_signup.job_fair_roles.find(params[:id])

    if @job_fair_role.update(job_fair_role_params)
      flash[:notice] = "Role saved!"
      redirect_to dashboard_path
    else
      flash[:error] = "We were unable to process your response. Please correct it and try again."
      render action: :edit
    end
  end

  private

  def job_fair_signup
    current_user.job_fair_signups.find(params[:job_fair_signup_id])
  end

  def job_fair_role_params
    params
      .require(:job_fair_role)
      .permit(
        :title,
        :description,
        :url
      )
  end
end
