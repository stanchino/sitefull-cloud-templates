class DeploymentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'is not included in the list') if attribute_changed?(record, attribute) && !in_list?(record, attribute, value)
  end

  private

  def in_list?(record, attribute, value)
    DeploymentDecorator.new(record).send(attribute.to_s.pluralize).include?(value)
  end

  def attribute_changed?(record, attribute)
    record.send("#{attribute}_changed?")
  end
end
