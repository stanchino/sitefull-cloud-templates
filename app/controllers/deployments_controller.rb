class DeploymentsController < ApplicationController
  include GenericActions

  load_and_authorize_resource :template, only: [:index, :new, :edit, :create, :destroy, :validate, :options]
  load_and_authorize_resource through: :template, only: [:destroy]
  load_and_authorize_resource through: :current_accounts_user, only: [:all, :show]

  before_action :load_provider_types, only: [:new, :create]
  before_action :load_deployments, only: :index
  before_action :new_deployment, only: [:new, :create, :options, :validate]
  before_action :setup_decorator, only: [:new, :create, :show, :validate, :options]
  authorize_resource except: [:index, :all, :destroy, :edit, :show]

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

  def deployment_params
    params.fetch(:deployment, {}).permit(:provider_id, :region, :image, :machine_type).tap do |whitelisted|
      whitelisted[:arguments] = params[:deployment][:arguments] if params[:deployment].present? && params[:deployment][:arguments].present?
    end
  end

  def options_params
    params.permit(:type)
  end

  def load_provider_types
    @providers = Provider.where(configured: true)
    redirect_to @deployment.template, alert: I18n.t('deployments.no_providers_configured') unless @providers.any?
  end

  def new_deployment
    attributes = deployment_params.merge(accounts_user: current_accounts_user)
    attributes[:provider] = current_organization.providers.find_by_textkey(params[:provider]) if params[:provider].present?
    @deployment ||= @template.deployments.build attributes
  end

  def load_deployments
    @deployments = current_user.deployments.where(AccountsUser.arel_table[:account_id].eq(current_user.current_account_id))
  end

  def setup_decorator
    @decorator = DeploymentDecorator.new(@deployment)
  end
end
