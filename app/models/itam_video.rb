# frozen_string_literal: true

# ItamVideo contains video card information
class ItamVideo < ApplicationRecord
  self.table_name = 'videos'
  belongs_to :itam_hardware
end
