require 'rails_helper'

RSpec.describe ApiAssetDetail, type: :model do
  it { should validate_presence_of(:name) }
end
