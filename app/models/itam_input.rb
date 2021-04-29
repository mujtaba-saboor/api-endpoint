# frozen_string_literal: true

# ItamInput contains keyboard mouse etc
class ItamInput < ApplicationRecord
  self.table_name = 'inputs'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
