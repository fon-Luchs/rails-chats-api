require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  it { should be_a ApplicationController }

  let(:user) { create(:user, :with_auth_token, :with_expected_additional_columns) }

  let(:users) { create_list :user, 3, :with_expected_additional_columns }

  let(:chat) { stub_model Chat, users: users }

  before { sign_in user }

  describe '#index' do
    let(:recipient) { create(:user, :with_expected_additional_columns) }

    before do
      expect(user).to receive_message_chain(:chats, :all).and_return(chat)
    end

    before { get :index, format: :json }

    it { expect(assigns(:chats)).to eq(chat) }
  end

  describe '#create' do
    let(:params) { { chat: { recipient_id: user.id.to_s } } }

    let(:permitted_params) { permit_params! params, :chat }

    before do
      expect(ChatBuilder).to receive(:new).with(permitted_params, user) do
        double.tap { |a| expect(a).to receive(:build).and_return(chat) }
      end
    end

    context 'creation success' do
      before { expect(chat).to receive(:save).and_return(true) }

      before { post :create, params: params, format: :json }

      it { expect(permitted_params.permitted?).to eq(true) }

      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end

    context 'creation fall' do
      before { expect(chat).to receive(:save).and_return(false) }

      before { chat.errors.add(:base, 'error') }

      before { post :create, params: params, format: :json }

      it { expect(response.body).to eq(chat.errors.messages.to_json) }
    end
  end

  describe '#show' do
    before { expect_set_chat }

    before { expect(chat).to receive(:chat_without_message?) }

    before { get :show, format: :json, params: { id: chat.id} }

    it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(chat).to_json) }
  end

  let(:user_chat) { stub_model UserChat }

  describe '#add' do
    before { expect_set_chat }

    before do
      expect(chat).to receive(:user_chats) do
        double.tap do |chat|
          expect(chat).to receive(:find_or_create_by)
            .with(user_id: user.id).and_return(user_chat)
        end
      end
    end

    context 'join success' do
      before { expect(user_chat).to receive(:save).and_return(true) }

      before { post :add, params: { id: chat.id }, format: :json }

      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end

    context 'join fail' do
      before { expect(user_chat).to receive(:save).and_return(false) }

      before { user_chat.errors.add(:base, 'error') }

      before { post :add, params: { id: chat.id }, format: :json }

      it { expect(response.body).to eq(user_chat.errors.messages.to_json) }
    end
  end

  describe '#leave' do
    before { expect_set_chat }

    before do
      expect(chat).to receive(:user_chats) do
        double.tap do |user_chat|
          expect(user_chat).to receive(:where).with(user_id: user.id) do
            double.tap { |uc| expect(uc).to receive(:destroy_all) }
          end
        end
      end
    end

    context 'chat alone' do
      before do
        expect(chat).to receive_message_chain(:users, :size, :<)
          .with(no_args).with(no_args).with(2)
          .and_return(true)
      end

      before { expect(chat).to receive(:destroy) }

      before { post :leave, params: { id: chat.id }, format: :json }

      it { expect(response).to have_http_status(410) }

      it { expect(response.body).to eq('Chat is inactive') }
    end

    context 'chat populus' do
      before { expect(chat).to receive(:users).and_return(chat.users).at_most(4).times }

      before do
        expect(chat.users).to receive_message_chain(:size, :<)
          .with(no_args).with(2).and_return(false)
      end

      before { post :leave, params: { id: chat.id }, format: :json }

      it { expect(response).to have_http_status(:ok) }

      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end
  end

  describe 'routes test' do
    it { should route(:get, '/profile/chats').to(action: :index) }

    it { should route(:get, '/profile/chats/1').to(action: :show, id: 1) }

    it { should route(:post, '/profile/chats').to(action: :create) }

    it { should route(:post, '/profile/chats/1/add').to(action: :add, id: 1) }

    it { should route(:delete, '/profile/chats/1/leave').to(action: :leave, id: 1) }
  end

  describe 'callbacks test' do
    it { should use_before_action(:set_chat) }

    it { should use_before_action(:resource) }
  end

  def expect_set_chat
    expect(Chat).to receive(:find).with(chat.id.to_s).and_return(chat)
  end
end
