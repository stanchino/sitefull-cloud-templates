# frozen_string_literal: true
module Templates
  class ArgumentsController < ApplicationController
    include GenericActions

    load_and_authorize_resource :template
    load_and_authorize_resource through: :template, class: 'TemplateArgument'

    layout false

    # GET /templates/:template_id/arguments/new
    def new
    end

    # GET /templates/:template_id/arguments/1/edit
    def edit
    end

    # DELETE /templates/:template_id/arguments/1
    # DELETE /templates/:template_id/arguments/1.json
    def destroy
      destroy_resource @argument, edit_template_url(@template), t('template_arguments.delete_success')
    end
  end
end
