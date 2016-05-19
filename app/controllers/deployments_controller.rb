class DeploymentsController < ApplicationController
  include GenericActions

  load_and_authorize_resource :template, only: [:index, :new, :edit, :create, :destroy, :validate, :options]
  load_and_authorize_resource through: :template, only: [:edit, :new, :destroy, :validate]
  load_and_authorize_resource only: [:all, :show]

  before_action :load_provider_types, only: [:new, :create]
  before_action :load_user_deployments, only: :index
  before_action :load_deployment, except: [:index, :all, :destroy, :edit, :show, :new]
  # before_action :set_provider, only: [:new, :create, :options]
  # before_action :set_accounts_user, only: [:new, :create]
  before_action :setup_decorator, only: [:new, :create, :show, :validate, :options]
  authorize_resource

  layout 'dashboard'

  # GET /deployments
  # GET /deployments.json
  def all
    render :index
  end

  # GET /templates/1/deployments
  # GET /templates/1/deployments.json
  def index
  end

  # GET /deployments/1
  # GET /deployments/1.json
  def show
  end

  # GET /templates/1/deployments/new
  def new
  end

  # POST /templates/1/deployments
  # POST /templates/1/deployments.json
  def create
    if @deployment.save
      handle_save_success @deployment, :created, 'Deployment was successfully created.'
    else
      handle_save_error @deployment.errors, :new
    end
  end

  # GET /templates/1/deployments/2
  # GET /templates/1/deployments/2.json
  def edit
  end

  # DELETE /templates/1/deployments/1
  # DELETE /templates/1/deployments/1.json
  def destroy
    destroy_resource @deployment, deployments_url, 'Deployment was successfully deleted.'
  end

  # POST /templates/1/deployments/validate.json
  def validate
    respond_to do |format|
      if @decorator.valid?
        format.json { head :no_content }
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  # POST /templates/1/deployments/options.json
  def options
    respond_to do |format|
      if @decorator.valid?
        @items = @decorator.send("#{options_params[:type]}_for_select")
        format.json { render }
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  def new_params
    params.permit(:provider, :template_id)
  end

  def deployment_params
    params.fetch(:deployment, {}).permit(:provider_id, :region, :image, :machine_type)
  end

  def options_params
    params.permit(:type)
  end

  def load_provider_types
    @providers = Provider.where(configured: true)
    redirect_to @deployment.template, alert: I18n.t('deployments.no_providers_configured') unless @providers.any?
  end

  def load_deployment
    provider = Provider.where(organization_id: current_organization.id, textkey: params[:provider]).first! if params[:provider].present?
    @deployment ||= Deployment
                    .where(template_id: @template.id)
                    .where(accounts_user_id: current_user.accounts_users.where(account_id: current_user.current_account_id).first!.id)
                    .where(provider_id: provider.id)
                    .first_or_initialize
    @deployment.assign_attributes deployment_params
  end

  def set_provider
    @deployment.provider_id = Provider.where(organization_id: current_organization.id, textkey: new_params[:provider] || deployment_params[:provider_type]).first!.id
  end

  def set_accounts_user
    @deployment.accounts_user_id = AccountsUser.where(user_id: current_user.id, account_id: current_user.current_account_id).first!.id
  end

  def load_user_deployments
    @deployments = Deployment.joins(:accounts_user).where(AccountsUser.arel_table[:account_id].eq(current_user.current_account_id))
  end

  def setup_decorator
    @decorator = DeploymentDecorator.new(@deployment)
  end
end
