ActiveAdmin.register User do
  include ActiveAdmin::AjaxFilter

  permit_params :avatar,
    :description,
    :is_admin,
    :is_venue_host,
    :linkedin_url,
    :name,
    :password,
    :password_confirmation,
    :team_position,
    :team_priority,
    :email,
    chaired_track_ids: [],
    cfp_extension_attributes: [:id, :expires_at, :_destroy]

  index do
    selectable_column
    column :avatar do |u|
      image_tag u.avatar.url(:thumb)
    end
    column :name
    column :email
    column :description
    column :is_admin
    column(:registrations) do |u|
      u.registrations.sort.map(&:year).join(", ")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :avatar, as: :file, hint: image_tag(f.object.avatar.url(:thumb))
      f.input :name
      f.input :description
      f.input :email
      f.input :linkedin_url
      f.input :team_position
      f.input :team_priority, as: :number, min: 0, max: 10, hint: "Lower values show first"
      f.input :password
      f.input :password_confirmation
      f.input :is_admin
      f.input :chaired_tracks, as: :check_boxes, collection: Track.in_display_order
      f.has_many :cfp_extension, heading: "CFP Extension", new_record: false do |a|
        a.input :expires_at, as: :datepicker
      end
    end

    f.actions
  end

  filter :name
  filter :email
  filter :is_admin

  controller do
    def scoped_collection
      resource_class.includes(:registrations)
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  action_item :grant_cfp_extension, only: %i[show] do
    unless resource.has_valid_cfp_extension?
      link_to "Grant CFP extension", grant_cfp_extension_admin_user_path(resource), method: :post
    end
  end

  member_action :grant_cfp_extension, method: :post do
    user = User.find(params[:id])
    user.create_cfp_extension!(expires_at: 7.days.from_now)
    redirect_to admin_user_path(user)
  end

  action_item :revoke_cfp_extension, only: %i[show] do
    if resource.has_valid_cfp_extension?
      link_to "Revoke CFP extension", revoke_cfp_extension_admin_user_path(resource), method: :post
    end
  end

  member_action :revoke_cfp_extension, method: :post do
    user = User.find(params[:id])
    user.cfp_extension.destroy!
    redirect_to admin_user_path(user)
  end

  show do
    tabs do
      tab :login do
        attributes_table(*(default_attribute_table_rows - %i[encrypted_password reset_password_token provider]))
      end
      tab :registrations do
        table_for user.registrations.order("year asc") do
          column :year
          column do |r|
            link_to "View", admin_user_registration_path(user, r)
          end
        end
      end
    end
  end
end
