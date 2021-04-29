class Api::V1::ErrorsController < ApplicationController
  skip_before_action :authorize_request

  def error_four_zero_four
    raise ActiveRecord::RecordNotFound, Message.not_found
  end
end
