# frozen_string_literal: true

# ItamPrinter contains printers information
class ItamPrinter < ApplicationRecord
  self.table_name = 'printers'
  belongs_to :itam_hardware
end
