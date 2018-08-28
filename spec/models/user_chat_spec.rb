require 'rails_helper'

RSpec.describe UserChat, type: :model do
  let(:users) do
    create_list :user, 10, :with_auth_token, :with_expected_additional_columns
  end

  context 'relation test' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end
  ################################################################
  context 'validate_users_in_chat_count' do
    let(:chat) { Chat.create(recipient_id: users.first.id) }

    it 'should expect is invalid' do
      users.map do |user|
        UserChat.create(user_id: user.id, chat_id: chat.id)
      end
      user_chat = UserChat.first
      expect(user_chat.validate_users_in_the_chat).to eq(['is invalid'])
    end
  end

  context 'validate_user_chats_count' do
    let(:user) { create(:user) }
    let(:nested_chats) do
      users.map do |user|
        create_list :chat, 1, recipient_id: user.id
      end
    end
    it 'should expect is invalid' do
      chats = nested_chats.flatten
      chats.map do |chat|
        UserChat.create(user_id: user.id, chat_id: chat.id)
      end
      user_chat = UserChat.first
      expect(user_chat.validate_user_chats_count).to eq(['is invalid'])
    end
    #######################################################################
  end
end
