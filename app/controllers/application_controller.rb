class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.html { redirect_to main_app.new_user_session_url, alert: exception.message }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  #   def azure_auth_callback
  #     code = params[:code]
  #     conn = Faraday.new(url: 'https://login.microsoftonline.com/') do |faraday|
  #       faraday.request :url_encoded             # form-encode POST params
  #       faraday.use Faraday::Response::Logger, Rails.logger
  #       faraday.adapter Faraday.default_adapter  # make requests with Net::HTTP
  #     end
  #
  #     response = conn.post do |req|
  #       req.url "/#{ENV['AAD_TENANT_ID']}/oauth2/token"
  #       req.body = { code: code, client_id: ENV['AAD_CLIENT_ID'], client_secret: ENV['AAD_CLIENT_SECRET'], grant_type: 'authorization_code', redirect_uri: 'http://localhost:5000/azure_auth_callback' }.to_query
  #     end
  #
  #     access_token = JSON.parse(response.body)
  #     abort access_token.inspect
  #     conn = Faraday.new(url: 'https://management.azure.com/')
  #     response = conn.get '/subscriptions' do |req|
  #       req.params['api-version'] = 'api-version=2014-04-01-preview'
  #       req.headers['Authorization'] = "Bearer #{access_token}"
  #     end
  #
  #     abort response.body.inspect
  #   end
  #
  #   def auth_callback
  #     abort request.env['omniauth.auth'].inspect
  #   end
  #
  #   def oauth_callback
  #     abort oauth_provider(oauth_params[:provider]).authorize!(oauth_params[:code]).inspect
  #   end
  #
  #   private
  #
  #   def oauth_params
  #     params.permit(:provider, :code)
  #   end
end
