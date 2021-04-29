# frozen_string_literal: true

# ItamMemory contains cpu ram memory
class ItamMemory < ApplicationRecord
  self.table_name = 'memories'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
