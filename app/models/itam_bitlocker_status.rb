# frozen_string_literal: true

# ItamBitlockerStatus contains drive security status
class ItamBitlockerStatus < ApplicationRecord
  self.table_name = 'bitlockerstatus'
  belongs_to :itam_hardware

  ENABLED = 'ENABLED'
  DISABLED = 'DISABLED'
end
