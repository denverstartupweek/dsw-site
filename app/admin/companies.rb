ActiveAdmin.register Company do
  include ActiveAdmin::AjaxFilter

  menu parent: "Users", priority: 1

  config.sort_order = "name_asc"

  permit_params :name,
    user_ids: []

  index do
    selectable_column
    column :name
    column :user_ids do |company|
      User.find(company.user_ids).map(&:name)
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :user_ids do |company|
        User.find(company.user_ids).map(&:name)
      end
    end
    active_admin_comments
  end

  batch_action :combine do |company_ids|
    companies = Company.find(company_ids)
    Company.combine!(*companies)
    redirect_to admin_companies_path
  end
end
