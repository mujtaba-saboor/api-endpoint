# frozen_string_literal: true

# ItamStorage contains computer storage
class ItamStorage < ApplicationRecord
  self.table_name = 'storages'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
