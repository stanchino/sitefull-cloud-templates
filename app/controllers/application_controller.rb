require 'google/apis/compute_v1'
require 'google/api_client/client_secrets'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: :google_auth_callback

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.html { redirect_to main_app.new_user_session_url, alert: exception.message }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  def google_auth_callback
    deployment = Deployment.find(deployment_id)
    service = DeploymentOauthGoogle.new(deployment)
    service.authorize! params[:code]
    google_auth_success
  rescue Signet::AuthorizationError
    google_auth_error 'Google authorization failure.'
  rescue ActiveRecord::RecordNotFound
    google_auth_error 'Deployment not found.'
  end

  private

  def google_auth_success
    redirect_to edit_template_deployment_path(template_id, deployment_id)
  end

  def google_auth_error(message)
    redirect_to new_template_deployment_path(template_id), alert: message
  end

  def template_id
    @template_id ||= session.delete(:template_id)
  end

  def deployment_id
    @deployment_id ||= session.delete(:deployment_id)
  end
end
