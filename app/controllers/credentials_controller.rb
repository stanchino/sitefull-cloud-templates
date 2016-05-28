class CredentialsController < ApplicationController
  include GenericActions

  before_action :template
  before_action :provider
  before_action :credential

  authorize_resource :template
  authorize_resource :provider
  authorize_resource :credential

  layout 'dashboard'

  def auth
    provider_decorator.authorize! auth_params[:code]
    @credential.token = provider_decorator.token.to_json
    redirect_to new_template_deployment_path(@template, provider: provider_textkey) if @credential.save
  end

  def new
    if provider_decorator.token.access_token.blank? || !@credential.valid?
      redirect_to provider_decorator.authorization_url
    else
      redirect_to new_template_deployment_path(@template, provider: provider_textkey)
    end
  end

  def create
    save :created, :new
  end

  def update
    save :ok, :edit
  end

  private

  def save(success_response, error_view)
    if @credential.update_attributes credential_params
      handle_save_success new_template_deployment_path(@template, provider: provider_textkey), success_response
    else
      handle_save_error @credential.errors, error_view
    end
  end

  def auth_params
    params.permit(:provider_textkey, :code, :scope, :state)
  end

  def credential_params
    params.fetch(:credential, {}).permit(:token, Sitefull::Cloud::Provider.all_required_options)
          .merge(session_name: "user_#{current_user.to_param}")
  end

  def template
    @template ||= auth_params[:state]
  end

  def provider_textkey
    @provider_textkey ||= auth_params[:provider_textkey]
  end

  def credential
    @credential ||= provider.credentials.where(account_id: current_user.current_account_id).first_or_initialize
  end

  def provider
    @provider ||= current_organization.providers.find_by_textkey! provider_textkey
  end

  def credentials_options(refresh = false)
    return @credentials_options if @credentials_options.present? && !refresh
    @credentials_options = CredentialsDecorator.new(@credential).to_h.merge(base_uri: request.base_url, state: @template)
  end

  def provider_decorator(refresh = false)
    return @provider_decorator if @provider_decorator.present? && !refresh
    @provider_decorator = ProviderDecorator.new(@provider, credentials_options(refresh))
  end
end
