class TemplatesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  layout 'dashboard'

  # GET /templates
  # GET /templates.json
  def index
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template.user = current_user
    respond_to do |format|
      if @template.save
        handle_save_success format, :created, 'Template was successfully created.'
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        handle_save_success format, :ok, 'Template was successfully updated.'
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def template_params
    params.require(:template).permit(:name, :os, :script, tag_list: [])
  end

  def handle_save_success(format, status, message)
    format.html { redirect_to @template, notice: message }
    format.json { render :show, status: status, location: @template }
  end
end
