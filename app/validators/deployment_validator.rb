class DeploymentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'is not included in the list') unless DeploymentDecorator.new(record).send(attribute.to_s.pluralize).include?(value)
  end
end
