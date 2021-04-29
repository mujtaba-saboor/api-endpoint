# frozen_string_literal: true

# ItamDrive contains drives information
class ItamDrive < ApplicationRecord
  self.table_name = 'drives'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
