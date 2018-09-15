require 'rails_helper'

RSpec.describe Chat, type: :model do
  context 'relations test' do
    it { should have_many(:user_chats).dependent(:destroy) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:users).through(:user_chats) }
  end

  context 'methods test' do
    let(:user) { build(:user) }

    let(:chat) { Chat.new(recipient_id: user.id) }

    it 'chat_without_message?' do
      chat.messages.new(body: 'i want to believe', user_id: user.id)
      expect(chat.chat_without_message?).to eq(chat.messages.last.body)
    end
  end
end
