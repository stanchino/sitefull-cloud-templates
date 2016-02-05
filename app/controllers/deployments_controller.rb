class DeploymentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :template, only: [:new, :create, :destroy]
  load_and_authorize_resource through: :template, only: [:new, :create, :destroy]
  load_and_authorize_resource only: [:index, :show]

  # GET /deployments
  # GET /deployments.json
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
      handle_save_error @deployment, :new
    end
  end

  # DELETE /templates/1/deployments/1
  # DELETE /templates/1/deployments/1.json
  def destroy
    @deployment.destroy
    respond_to do |format|
      format.html { redirect_to deployments_url, notice: 'Deployment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def deployment_params
    params.require(:deployment).permit(:provider, :credentials, :image, :flavor, :template_id)
  end
end
