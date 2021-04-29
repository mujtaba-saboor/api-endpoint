# frozen_string_literal: true

# ItamCpu contains cpu information
class ItamCpu < ApplicationRecord
  self.table_name = 'cpus'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
