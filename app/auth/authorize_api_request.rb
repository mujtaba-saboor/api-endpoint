# frozen_string_literal: true

# authorize_api_request contains authentication of API token

class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
      company: company
    }
  end

  private

  attr_reader :headers

  def company
    @company ||= ApiCompany.find_by!(access_token: api_access_token) if api_access_token.present?
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken, "#{Message.invalid_token}: #{e.message}"
  end

  def api_access_token
    @api_access_token ||= http_auth_header
  end

  def http_auth_header
    return headers['HTTP_TOKEN'] if headers['HTTP_TOKEN'].present?

    raise ExceptionHandler::MissingToken, Message.missing_token
  end
end
