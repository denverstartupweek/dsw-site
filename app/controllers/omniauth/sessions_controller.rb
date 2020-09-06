class Omniauth::SessionsController < ApplicationController
  before_action :ensure_admin!

  def create
    @service = OauthService.find_or_create_from_auth_hash(auth_hash, current_user)
    redirect_to admin_oauth_services_path
  end

  def failure
    flash[:notice] = params[:message]
    redirect_to admin_oauth_services_path
  end

  protected

  def auth_hash
    request.env["omniauth.auth"]
  end
end
