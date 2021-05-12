# frozen_string_literal: true

# ItamController contains controller information
class ItamController < ApplicationRecord
  self.table_name = 'controllers'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
