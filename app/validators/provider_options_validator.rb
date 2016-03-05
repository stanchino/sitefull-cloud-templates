class ProviderOptionsValidator < ActiveModel::Validator
  def validate(record)
    return unless record.provider_type.present?
    Sitefull::Cloud::Provider.required_options_for(record.provider_type).each do |option|
      record.errors[option] << (options[:message] || 'is required') unless record.send(option).present?
    end
  end
end
