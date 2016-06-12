# Validate an email field
#
# A blank value is considered valid (use presence validator to check for that)
#
# Examples
#   validates :email, email: true                 # optional
#   validates :email, email: true, presence: true # required
class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /^(?=[a-z0-9][a-z0-9@._%+-]{5,253}$)[a-z0-9._%+-]{1,64}@(?:(?=[a-z0-9-]{1,63}\.)[a-z0-9]+(?:-[a-z0-9]+)*\.){1,8}[a-z]{2,63}$/i

  def validate_each(record, attr_name, value)
    return if value.blank?
    record.errors.add(attr_name, :email, options) unless value =~ EMAIL_REGEX
  end
end
