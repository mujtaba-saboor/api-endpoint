class Api::V1::ItAssetsController < ApplicationController
  before_action :load_itam_hardware, only: %i[update show]

  def show
    render json: @itam_hardware
  end

  def index
    api_service_result = ItAssetsApiService.new(@current_company).fetch_it_assets(params)
    json_response(api_service_result[:api_response], api_service_result[:status_code])
  end

  def create
    api_service_result = ItAssetsApiService.new(@current_company).create_it_asset(params)
    json_response(api_service_result[:api_response], api_service_result[:status_code])
  end

  def update
    api_service_result = ItAssetsApiService.new(@current_company).update_it_asset(@itam_hardware, params)
    json_response(api_service_result[:api_response], api_service_result[:status_code])
  end

  def load_itam_hardware
    @itam_hardware = @current_company.itam_hardwares.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    json_response({ message: I18n.t(:itam_hardware_not_found, device_id: params[:id]) }, :not_found)
  end
end
