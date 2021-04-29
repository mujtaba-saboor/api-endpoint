# frozen_string_literal: true

# ItamMonitor contains monitors
class ItamMonitor < ApplicationRecord
  self.table_name = 'monitors'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
