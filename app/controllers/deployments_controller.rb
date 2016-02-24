class DeploymentsController < ApplicationController
  include GenericActions

  load_and_authorize_resource :template, only: [:index, :new, :create, :destroy, :validate, :options]
  load_and_authorize_resource through: :template, only: [:index, :new, :create, :destroy, :validate, :options]
  load_and_authorize_resource only: [:all, :show]

  before_action :setup_decorator, only: [:new, :create, :validate, :options]

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
    GoogleAuthService.new(@deployment).authorize(request)
  end

  # POST /templates/1/deployments
  # POST /templates/1/deployments.json
  def create
    if DeploymentStatusService.new(@deployment).save
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
  def deployment_params
    params.require(:deployment).permit(:provider_type, :region, :image, :flavor, Provider::Aws::CREDENTIALS, Provider::Google::CREDENTIALS)
  end

  def options_params
    params.permit(:type)
  end

  def setup_decorator
    @decorator = DeploymentDecorator.new(@deployment || @template.deployments.build(deployment_params))
  end
end
