ActiveAdmin.register OauthService do
  menu parent: "Site Content"

  config.filters = false

  actions :all, except: [:new, :show]

  permit_params :description

  index do
    selectable_column
    column :provider do |s|
      s.provider.titleize
    end
    column :uid
    column :user
    column :description
    actions
  end

  action_item :connect_zoom, only: :index do
    link_to "Connect Zoom account", "/auth/zoom"
  end

  action_item :connect_youtube, only: :index do
    link_to "Connect Youtube account", "/auth/youtube"
  end

  form do |f|
    f.inputs do
      f.input :description
    end
    f.actions
  end
end
