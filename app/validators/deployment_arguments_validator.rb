# Validate deployment arguments
#
# Example usage:
#
# validates_with DeploymentArgumentsValidator, messages: { missing: 'can\'t be blank', invalid: 'is invalid' }
#

class DeploymentArgumentsValidator < ActiveModel::Validator
  VALIDATORS = {
    alphanumeric: /^\w+$/i,
    domain: /^(?:(?=[a-z0-9-]{1,63}\.)[a-z0-9]+(?:-[a-z0-9]+)*\.){1,8}[a-z]{2,63}$/i,
    email: EmailValidator::EMAIL_REGEX,
    name: /^[a-z]+$/i
  }.freeze

  def validate(record)
    return unless record.template.present? || record.template.arguments.blank?
    record.template.arguments.each do |argument|
      value = record.arguments.try(:[], argument.textkey.to_s)
      validate_presence record, argument, value
      validate_value record, argument, value
    end
  end

  private

  def validate_presence(record, argument, value)
    add_error(record, argument.textkey, :missing, 'can\'t be blank') if argument.required? && value.blank?
  end

  def validate_value(record, argument, value)
    add_error(record, argument.textkey, :invalid, 'is invalid') unless valid?(argument, value)
  end

  def add_error(record, textkey, error, default)
    record.errors['arguments'] << { textkey => message_for(error, default) }
  end

  def valid?(argument, value)
    return true if value.blank? && !argument.required?
    value =~ VALIDATORS[argument.validator.to_sym]
  end

  def message_for(error, default)
    options[:messages].try(:[], error) || default
  end
end
