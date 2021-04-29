require 'rails_helper'

RSpec.describe ApiCompany, type: :model do
  it { should validate_presence_of(:access_token) }
  it { should validate_presence_of(:itam_company_id) }
end
