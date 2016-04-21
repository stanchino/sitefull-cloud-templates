module DeploymentsHelper
  def provider_blank?
    @deployment.provider_type.blank?
  end

  def provider_options_urls
    Hash[[:regions, :images, :machine_types].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item)] }]
  end

  def options_for_selection(provider_type)
    options = { checked: @deployment.provider_type == provider_type }

    options.merge(data: { 'oauth-url' => ProviderDecorator.new(provider_type, oauth_url_options(provider_type)).authorization_url })
  end

  def deployment_progress(state)
    if @deployment.completed? || (!@deployment.failed? && state_success?(state))
      ['completed', I18n.t("deployment_states.#{state}.after")]
    elsif @deployment.failed?
      failed_progress state
    elsif @deployment.send("#{state}?")
      ['running', I18n.t("deployment_states.#{state}.before")]
    else
      ['hidden', I18n.t("deployment_states.#{state}.before")]
    end
  end

  def deployment_state
    @deployment_state ||= if @deployment.completed?
                            @decorator.instance_data.present? ? 'completed' : 'instance-missing'
                          else
                            @deployment.failed? ? 'failed' : 'running'
                          end
  end

  def deployment_failed?
    @deployment.failed? || deployment_state == 'instance-missing'
  end

  private

  def states
    @states ||= Deployment::RUNNING_STATES.map(&:first)
  end

  def failed_progress(state)
    if states.index(state) < states.index(@deployment.failed_state.to_sym)
      ['completed', I18n.t("deployment_states.#{state}.after")]
    elsif state == @deployment.failed_state.to_sym
      ['failed', I18n.t("deployment_states.#{state}.failed")]
    else
      ['hidden', I18n.t("deployment_states.#{state}.before")]
    end
  end

  def state_success?(state)
    states.include?(@deployment.state.to_sym) && states.index(state) < states.index(@deployment.state.to_sym)
  end

  def oauth_url_options(provider_type)
    { base_uri: request.base_url, state: new_template_deployment_path(@deployment.template, provider: provider_type) }
  end
end
