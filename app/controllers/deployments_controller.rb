class DeploymentsController < ApplicationController
  include GenericActions

  load_and_authorize_resource :template, only: [:index, :new, :create, :destroy, :validate, :options]
  load_and_authorize_resource through: :template, only: [:index, :new, :create, :destroy, :validate, :options]
  load_and_authorize_resource only: [:all, :show]

  before_action :set_provider_type, only: [:new, :create]
  before_action :setup_decorator, only: [:new, :create, :show, :validate, :options]

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

  # Never trust parameters from the scary internet, only allow the white list through.
  def new_params
    params.permit(:provider)
  end

  def deployment_params
    params.require(:deployment).permit(:provider_type, :region, :image, :machine_type, Sitefull::Cloud::Provider.all_required_options)
  end

  def options_params
    params.permit(:type)
  end

  def set_provider_type
    @deployment.provider_type = new_params[:provider] if new_params[:provider].present?
  end

  def setup_decorator
    @decorator = DeploymentDecorator.new(@deployment || @template.deployments.build(deployment_params))
    @decorator.deployment.user = current_user unless @decorator.deployment.user.present?
    @decorator.deployment.session_name = request.session_options[:id]
  end
end
