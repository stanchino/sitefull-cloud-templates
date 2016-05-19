class ProviderOptionsValidator < ActiveModel::Validator
  def validate(record)
    return unless record.provider.present?
    error = valid?(record)
    required_options_for(record.provider.textkey).each do |option|
      record.errors[option] << (options[:message] || 'is required') unless record.send(option).present?
      record.errors[option] << error if error.is_a? String
    end
  end

  private

  def required_options_for(textkey)
    Sitefull::Cloud::Provider.required_options_for(textkey)
  end

  def valid?(record)
    ProviderDecorator.new(record.provider, credentials_options(record)).provider.try(:valid?)
  rescue StandardError => e
    e.message
  end

  def credentials_options(record)
    CredentialsDecorator.new(record).to_h
  end
end
