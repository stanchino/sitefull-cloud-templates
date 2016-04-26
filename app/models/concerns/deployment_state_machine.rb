module DeploymentStateMachine
  extend ActiveSupport::Concern

  RUNNING_STATES = [
    [:creating_network, :network_setup],
    [:creating_firewall_rules, :firewall_setup],
    [:creating_access_key, :access_setup],
    [:creating_instance, :instance_setup],
    [:starting_instance, :instance_state],
    [:executing_script, :script_execution]
  ].freeze

  included do
    state_machine initial: :running do
      before_transition running: any - :running, do: :notify_status
      before_transition any - [:running, :completed, :failed] => any - [:running, :failed], do: :notify_before_transition
      after_transition any - [:completed, :failed] => any - [:running, :completed, :failed], do: :notify_after_transition
      after_transition any - :completed => :completed, do: :notify_status

      event(:reset) { transition any => :running }
      event(:started) { transition running: :creating_network }
      event(:network_created) { transition creating_network: :creating_firewall_rules }
      event(:firewall_rules_created) { transition creating_firewall_rules: :creating_access_key }
      event(:access_key_created) { transition creating_access_key: :creating_instance }
      event(:instance_created) { transition creating_instance: :starting_instance }
      event(:instance_started) { transition starting_instance: :executing_script }
      event(:script_executed) { transition executing_script: :completed }

      before_transition any - [:running, :completed, :failed] => :failed, do: :notify_failed_event
      after_transition any - :failed => :failed, do: :notify_status

      event(:failed) { transition any => :failed }
    end

    def fail_with_error(message)
      self.error = message
      failed
    end

    def change_state(state, attrs = {})
      update_attributes attrs if attrs.present?
      send(state)
    end

    def notify_before_transition
      notify_progress :after, :completed
    end

    def notify_after_transition
      notify_progress :before, :running
    end

    def notify_failed_event
      update_attributes(failed_state: state)
      notify_progress :failed, :failed, error: error
    end

    def notify_output(message)
      WebsocketRails[:deployments].trigger :output, id: id, message: message
    end

    private

    def notify_progress(progress, status, data = {})
      WebsocketRails[:deployments].trigger :progress, { id: id, message: I18n.t("deployment_states.#{state}.#{progress}"), key: RUNNING_STATES.to_h[state.to_sym], status: status }.merge(data)
    end

    def notify_status
      WebsocketRails[:deployments].trigger :status, id: id, status: state
    end
  end
end
