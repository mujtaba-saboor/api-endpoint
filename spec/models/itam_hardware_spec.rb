require 'rails_helper'

RSpec.describe ItamHardware, type: :model do
  it { should validate_presence_of(:name) }
end
