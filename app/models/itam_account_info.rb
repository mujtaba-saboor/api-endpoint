# frozen_string_literal: true

# ItamAccountInfo contains access_token
class ItamAccountInfo < ApplicationRecord
  self.table_name = 'accountinfo'
  belongs_to :itam_hardware, foreign_key: :hardware_id
  belongs_to :api_company, foreign_key: :itam_company_id, primary_key: :itam_company_id

  validates_presence_of :access_token
end
