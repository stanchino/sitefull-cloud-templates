# frozen_string_literal: true
class CredentialsDecorator
  def initialize(credentials)
    @credentials = credentials
  end

  def to_h
    @hash ||= (@credentials.data || {}).merge(token: @credentials.try(:token))
  end
end
