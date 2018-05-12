require 'rails_helper'

RSpec.describe Tat, type: :model do
  it 'has a valid factory' do
    expect(create :tat).to be_valid
  end

  it 'creates a temporary user on create unless an user_id is provided', :aggregate_failures do
    tat = create :tat, user_id: nil
    expect(tat).to be_valid
    expect(tat.user).not_to be_nil
    expect(tat.user.email).to start_with 'tatuser_'
  end
end
