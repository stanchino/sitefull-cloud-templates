module DeploymentsHelper
  def provider_blank?
    @deployment.provider.blank?
  end

  def provider_options_urls
    Hash[[:regions, :images, :machine_types].map { |item| ["#{item}-url", options_template_deployments_url(@template, type: item, provider: @deployment.provider.try(:textkey))] }]
  end

  def options_for_selection(provider_type)
    { checked: @deployment.provider_textkey == provider_type, data: { 'provider-textkey' => provider_type, 'auth-url' => new_provider_credential_path(provider_type, state: @deployment.template_id) } }
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
    if state_not_failed?(state)
      ['completed', I18n.t("deployment_states.#{state}.after")]
    elsif state_failed?(state)
      ['failed', I18n.t("deployment_states.#{state}.failed")]
    else
      ['hidden', I18n.t("deployment_states.#{state}.before")]
    end
  end

  def state_not_failed?(state)
    @deployment.failed_state.present? && states.index(state) < states.index(@deployment.failed_state.to_sym)
  end

  def state_failed?(state)
    @deployment.failed_state.nil? || state == @deployment.failed_state.to_sym
  end

  def state_success?(state)
    states.include?(@deployment.state.to_sym) && states.index(state) < states.index(@deployment.state.to_sym)
  end
end
