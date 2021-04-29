# frozen_string_literal: true

class ItamBiosSerializer < ActiveModel::Serializer
  attribute :ssn, key: :serial_number
  attribute :smanufacturer, key: :bios_manufacturer
  attribute :bversion, key: :bios_version
  attribute :smodel, key: :bios_model

end
