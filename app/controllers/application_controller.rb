# frozen_string_literal: true

# ApplicationController gets called before each controller
class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include EzUtilities

  before_action :authorize_request
  attr_reader :current_company

  def authorize_request
    @current_company = AuthorizeApiRequest.new(request.headers).call[:company]
  end
end
