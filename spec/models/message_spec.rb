require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user)    { stub_model User }
  let(:message) { stub_model Message, user: user }
  subject { message }
  context 'relation test' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end

  context 'validation test' do
    it { should validate_presence_of(:user_name) }
    it { should validate_length_of(:body).is_at_least(3).is_at_most(255) }
  end

  context 'delegete test' do
    it { should delegate_method(:name).to(:user).with_prefix('user') } # <~~
  end
end
