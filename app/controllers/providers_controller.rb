class ProvidersController < ApplicationController
  load_and_authorize_resource find_by: :textkey

  before_action :provider_decorator, only: :oauth

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

  def provider_decorator
    @provider_decorator ||= ProviderDecorator.new(oauth_params[:id], base_uri: request.base_url).auth
  end
end
