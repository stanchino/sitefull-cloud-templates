class ProviderOptionsValidator < ActiveModel::Validator
  def validate(record)
    return unless record.provider_type.present?
    "Provider::#{record.provider_type.capitalize}::REQUIRED_OPTIONS".constantize.each do |option|
      record.errors[option] << (options[:message] || 'is required') unless record.send(option).present?
    end
  end
end
