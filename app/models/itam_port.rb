# frozen_string_literal: true

# ItamPort contains ports information
class ItamPort < ApplicationRecord
  self.table_name = 'ports'
  belongs_to :itam_hardware
  self.inheritance_column = :_type_disabled

end
