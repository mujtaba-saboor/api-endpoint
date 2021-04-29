# frozen_string_literal: true

# Message.rb contains all the relevant error messages

class Message
  def self.not_found(record = 'Resource')
    "#{record} not found."
  end

  def self.something_went_wrong
    'Something went wrong'
  end

  def self.invalid_token
    'Invalid API token'
  end

  def self.missing_token
    'Missing API token'
  end

  def self.unauthorized
    'Unauthorized request'
  end
end
