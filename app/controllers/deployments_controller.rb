class DeploymentsController < ApplicationController
  include GenericActions

  load_and_authorize_resource :template, only: [:index, :new, :create, :destroy, :options]
  load_and_authorize_resource through: :template, only: [:index, :new, :create, :destroy, :options]
  load_and_authorize_resource only: [:all, :show]

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

  # DELETE /templates/1/deployments/1
  # DELETE /templates/1/deployments/1.json
  def destroy
    destroy_resource @deployment, deployments_url, 'Deployment was successfully deleted.'
  end

  # POST /templates/1/deployments/options.json
  def options
    @deployment = @deployments.new(deployment_params)
    respond_to do |format|
      if @deployment.provider.respond_to?(:valid?) && @deployment.provider.valid?
        format.json { render }
      else
        format.json { render json: { errors: ['Invalid credentials provider'] }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def deployment_params
    params.require(:deployment).permit(:provider_type, :region, :flavor, Providers::Aws::CREDENTIALS)
  end
end
