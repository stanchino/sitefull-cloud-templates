class ProvidersController < ApplicationController
  include GenericActions

  load_and_authorize_resource find_by: :textkey, only: :oauth
  load_and_authorize_resource except: :oauth

  before_action :provider_decorator, only: :oauth

  layout 'dashboard', except: :oauth

  def create
    if @provider.save
      handle_save_success edit_provider_url(@provider), :created, t('providers.create_success')
    else
      handle_save_error @provider.errors, :new
    end
  end

  def update
    if @provider.update(provider_params)
      handle_save_success providers_url, :ok, t('providers.update_success')
    else
      handle_save_error @provider.errors, :edit
    end
  end

  def destroy
    destroy_resource @provider, providers_url, t('providers.delete_success')
  end

  def oauth
    @provider_decorator.authorize!(oauth_params[:code])
    access = @provider.accesses.where(user_id: current_user.id).first_or_initialize
    access.update_attributes(token: @provider_decorator.token.to_json)
    redirect_to oauth_params[:state]
  end

  private

  def oauth_params
    params.permit(:id, :code, :scope, :state)
  end

  def provider_params
    params.require(:provider).permit(:textkey, :name, settings_attributes: [:id, :name, :value])
  end

  def provider_decorator
    @provider_decorator ||= ProviderDecorator.new(oauth_params[:id], base_uri: request.base_url).auth
  end
end
