# frozen_string_literal: true

# ExceptionHandler contains error handling
module ExceptionHandler
  extend ActiveSupport::Concern

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  included do
    rescue_from Exception, with: :five_hundred
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound, with: :four_zero_four
  end

  private

  # Status code 422 - unprocessable entity
  def four_twenty_two(error)
    json_response({ message: error.message }, :unprocessable_entity)
  end

  # Status code 404 - resoruce not found
  def four_zero_four(error)
    json_response({ message: error.message }, :not_found)
  end

  # Status code 500 - internal server error
  def five_hundred(_error)
    json_response({ message: Message.something_went_wrong }, :internal_server_error)
  end
end
