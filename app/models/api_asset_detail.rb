# frozen_string_literal: true

# ApiAssetDetail contains immediate details of an it-asset

class ApiAssetDetail < ApplicationRecord
  belongs_to :itam_hardware, foreign_key: :hardware_id

  validates :name, presence: true, length: { maximum: 100, minimum: 3 }
  validates_presence_of :purchased_on

  NAME_LIMIT = { upper: 100, lower: 3 }.freeze
end
