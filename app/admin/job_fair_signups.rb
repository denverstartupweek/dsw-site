ActiveAdmin.register JobFairSignup do
  menu parent: "Sessions"

  permit_params :actively_hiring,
    :company_id,
    :contact_email,
    :covid_impact,
    :industry_category,
    :notes,
    :number_hiring_next_12_months,
    :number_open_positions,
    :organization_size,
    :user_id,
    :state,
    :year

  index do
    selectable_column
    column :year
    column :state do |s|
      status_tag s.state.to_s.titleize, class: status_for_job_fair_signup(s)
    end
    column :company do |s|
      s.company.name
    end
    column :user do |s|
      s.user.name
    end
    column :actively_hiring
    column :number_open_positions
    column :number_hiring_next_12_months
    column :industry_category
    column :organization_size
    actions
  end

  controller do
    def scoped_collection
      resource_class.includes(:user, :company)
    end
  end

  # Set a default year filter
  scope("Current", default: true, &:for_current_year)
  scope("Previous Years", &:for_previous_years)

  filter :company_name
  filter :user_name
  filter :actively_hiring
  filter :number_open_positions
  filter :number_hiring_next_12_months
  filter :industry_category
  filter :organization_size
  filter :state

  form do |f|
    f.inputs do
      f.input :year
      f.input :company_id,
        as: :ajax_select,
        data: {
          url: filter_admin_companies_path,
          search_fields: [:name],
          ajax_search_fields: [:company_id]
        }
      f.input :user_id,
        as: :ajax_select,
        data: {
          url: filter_admin_users_path,
          search_fields: %i[name email],
          ajax_search_fields: [:user_id]
        }

      f.input :industry_category, as: :select, collection: JobFairSignup::INDUSTRY_CATEGORIES, include_blank: false
      f.input :organization_size, as: :select, collection: JobFairSignup::ORGANIZATION_SIZES, include_blank: false
      f.input :state, as: :select, collection: JobFairSignup.states.map { |s| [s.to_s.titleize, s] }, include_blank: false
      f.input :contact_email
      f.input :actively_hiring
      f.input :number_open_positions
      f.input :number_hiring_next_12_months
      f.input :covid_impact
      f.input :notes
    end
    f.actions
  end

  action_item :accept, only: :show do
    unless job_fair_signup.accepted?
      link_to "Accept",
        accept_admin_job_fair_signup_path(job_fair_signup),
        method: :post
    end
  end

  member_action :accept, method: :post do
    job_fair_signup = JobFairSignup.find(params[:id])
    job_fair_signup.accept!
    redirect_to admin_job_fair_signup_path(job_fair_signup)
  end

  batch_action :accept do |job_fair_signup_ids|
    JobFairSignup.find(job_fair_signup_ids).each(&:accept!)
    redirect_to admin_job_fair_signups_path
  end

  action_item :reject, only: :show do
    unless job_fair_signup.rejected?
      link_to "Reject",
        reject_admin_job_fair_signup_path(job_fair_signup),
        method: :post
    end
  end

  member_action :reject, method: :post do
    job_fair_signup = JobFairSignup.find(params[:id])
    job_fair_signup.reject!
    redirect_to admin_job_fair_signup_path(job_fair_signup)
  end

  batch_action :reject do |job_fair_signup_ids|
    JobFairSignup.find(job_fair_signup_ids).each(&:reject!)
    redirect_to admin_job_fair_signups_path
  end
end
