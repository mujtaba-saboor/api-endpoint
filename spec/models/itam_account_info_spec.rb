require 'rails_helper'

RSpec.describe ItamAccountInfo, type: :model do
  it { should validate_presence_of(:access_token) }
end
