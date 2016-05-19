class CredentialsController < ApplicationController
  include GenericActions

  before_action :assign_template
  before_action :assign_provider_textkey
  before_action :setup_provider
  before_action :setup_credential

  before_action :credentials_decorator
  before_action :provider_decorator

  authorize_resource :provider
  authorize_resource :credential

  layout 'dashboard'

  def auth
    @provider_decorator.authorize!(auth_params[:code])
    @credential.token = @provider_decorator.auth.token.to_json
  end

  def new
    if !@provider_decorator.auth.token.access_token.present?
      redirect_to @provider_decorator.authorization_url
    elsif @provider_decorator.provider.valid?
      redirect_to new_template_deployment_path(@template_id, provider: @provider_textkey)
    end
  end

  def create
    if @credential.valid? && @credential.save!
      handle_save_success new_template_deployment_path(@template_id, provider: @provider_textkey), :created
    else
      handle_save_error @credential.errors, :new
    end
  end

  def update
    if @credential.save
      handle_save_success new_template_deployment_path(@template_id, provider: @provider_textkey), :ok
    else
      handle_save_error @credential.errors, :edit
    end
  end

  private

  def auth_params
    params.permit(:provider_textkey, :code, :scope, :state)
  end

  def credentials_params
    params.fetch(:credential, {}).permit(:token, Sitefull::Cloud::Provider.all_required_options)
          .merge(session_name: "user_#{current_user.to_param}")
  end

  def assign_template
    @template_id ||= auth_params[:state]
  end

  def assign_provider_textkey
    @provider_textkey ||= auth_params[:provider_textkey]
  end

  def setup_credential
    @credential ||= Credential.joins(:provider)
                              .where(provider_id: @provider.id)
                              .where(account_id: current_user.current_account_id)
                              .first_or_initialize
    @credential.assign_attributes credentials_params
  end

  def setup_provider
    @provider ||= current_organization.providers.where(textkey: @provider_textkey).first!
  end

  def credentials_decorator
    @credentials_decorator ||= CredentialsDecorator.new(@credential)
  end

  def provider_decorator
    @provider_decorator ||= ProviderDecorator.new(@provider, @credentials_decorator.to_h.merge(base_uri: request.base_url, state: @template_id))
  end
end
