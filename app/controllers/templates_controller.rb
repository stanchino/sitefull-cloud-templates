class TemplatesController < ApplicationController
  include GenericActions

  load_and_authorize_resource

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
    if @template.save
      handle_save_success @template, :created, t('templates.create_success')
    else
      handle_save_error @template.errors, :new
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    if @template.update(template_params)
      handle_save_success @template, :ok, t('templates.update_success')
    else
      handle_save_error @template.errors, :edit
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    destroy_resource @template, templates_url, t('templates.delete_success')
  end

  private

  def template_params
    params.require(:template).permit(:name, :os, :script, tag_list: []).tap do |whitelisted|
      whitelisted[:arguments_attributes] = params[:template][:arguments_attributes] if params[:template][:arguments_attributes].present?
    end
  end
end
