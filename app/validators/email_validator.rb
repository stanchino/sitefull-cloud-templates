# frozen_string_literal: true
# Validate an email field
#
# A blank value is considered valid (use presence validator to check for that)
#
# Examples
#   validates :email, email: true                 # optional
#   validates :email, email: true, presence: true # required
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    return if value.blank?
    record.errors.add(attr_name, :email, options) unless value =~ DeploymentArgumentsValidator::VALIDATORS[:email]
  end
end
