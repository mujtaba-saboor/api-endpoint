# frozen_string_literal: true

# ItamBios contains bios information
class ItamBios < ApplicationRecord
  self.table_name = 'bios'
  self.inheritance_column = :_type_disabled

  belongs_to :itam_hardware, foreign_key: :hardware_id

end
