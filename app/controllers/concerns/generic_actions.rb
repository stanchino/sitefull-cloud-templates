module GenericActions
  extend ActiveSupport::Concern

  protected

  def destroy_resource(resource, redirect_url, message)
    resource.destroy
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: message }
      format.json { head :no_content }
    end
  end

  def handle_save_success(redirect_url, json_status, message = nil)
    respond_to do |format|
      format.html { redirect_to redirect_url, notice: message }
      format.json { render :show, status: json_status, location: redirect_url }
    end
  end

  def handle_save_error(errors, action)
    respond_to do |format|
      format.html do
        flash.now[:alert] = errors.full_messages.join(', ')
        render action
      end
      format.json { render json: errors, status: :unprocessable_entity }
    end
  end
end
