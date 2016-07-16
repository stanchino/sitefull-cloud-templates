# frozen_string_literal: true
class ProviderOptionsValidator < ActiveModel::Validator
  def validate(record)
    return unless record.provider.present?
    error = valid?(record)
    required_options_for(record.provider.textkey).each do |option|
      validate_presence_of record, option
      validate_provider_settings record, option, error
    end
  end

  private

  def validate_presence_of(record, option)
    record.errors[option] << (options[:message] || 'is required') unless record.send(option).present?
  end

  def validate_provider_settings(record, option, error)
    if error.is_a? String
      record.errors[option] << error
    elsif !error
      record.errors[option] << 'invalid setting'
    end
  end

  def required_options_for(textkey)
    Sitefull::Cloud::Provider.required_options_for(textkey)
  end

  def valid?(record)
    ProviderDecorator.new(record.provider, credentials_options(record)).valid?
  rescue StandardError => e
    e.message
  end

  def credentials_options(record)
    CredentialsDecorator.new(record).to_h
  end
end
