class ProvidersController < ApplicationController
  include GenericActions

  load_and_authorize_resource through: :current_organization

  layout 'dashboard'

  def create
    if @provider.save
      handle_save_success edit_provider_url(@provider), :created, t('providers.create_success')
    else
      handle_save_error @provider.errors, :new
    end
  end

  def update
    if @provider.update provider_params.merge(configured: true)
      handle_save_success providers_url, :ok, t('providers.update_success')
    else
      handle_save_error @provider.errors, :edit
    end
  end

  def destroy
    destroy_resource @provider, providers_url, t('providers.delete_success')
  end

  private

  def provider_params
    params.require(:provider).permit(:textkey, :name, settings_attributes: [:id, :name, :value])
  end
end
