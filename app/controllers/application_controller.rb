class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  protected

  def handle_save_success(resource, status, message)
    respond_to do |format|
      format.html { redirect_to resource, notice: message }
      format.json { render :show, status: status, location: resource }
    end
  end

  def handle_save_error(resource, action)
    respond_to do |format|
      format.html { render action }
      format.json { render json: resource.errors, status: :unprocessable_entity }
    end
  end
end
