# frozen_string_literal: true

# ItamSoftware contains software_information
class ItamSoftware < ApplicationRecord
  self.table_name = 'softwares'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

  API = 'api'
end
