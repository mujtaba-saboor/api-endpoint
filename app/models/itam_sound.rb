# frozen_string_literal: true

# ItamSound contains sound drivers
class ItamSound < ApplicationRecord
  self.table_name = 'sounds'
  belongs_to :itam_hardware
end
