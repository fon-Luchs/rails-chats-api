require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation test' do
    it { should have_secure_password }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'relation test' do
    it { should have_one(:auth_token).dependent(:destroy) }
    it { should have_many(:chats).through(:user_chats) }
    it { should have_many(:user_chats).dependent(:destroy) }
    it { should have_many(:messages) }
  end
end
