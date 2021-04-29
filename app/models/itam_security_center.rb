# frozen_string_literal: true

# ItamSecurityCenter contains hardware security
class ItamSecurityCenter < ApplicationRecord
  self.table_name = 'securitycenter'
  belongs_to :itam_hardware
end
