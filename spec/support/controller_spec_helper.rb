# frozen_string_literal: true

module ControllerSpecHelper
  def token_generator
    SecureRandom.hex
  end

  def valid_headers
    {
      'HTTP_TOKEN' => token_generator,
      'Content-Type' => 'application/json'
    }
  end

  def invalid_headers
    {
      'HTTP_TOKEN' => nil,
      'Content-Type' => 'application/json'
    }
  end
end
