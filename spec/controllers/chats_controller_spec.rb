require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  it { should be_a ApplicationController }

  let(:chat) { stub_model Chat}
  let(:random_id) { FFaker::Random.rand(10..1000) }
  let(:user) { stub_model User }
  before { sign_in user }

  context 'callbacks test' do
    it { should use_before_action(:set_chat) }
  end

  context 'routes test' do
    it { should route(:get, '/profile/chats').to(action: :index) }
    it { should route(:get, '/profile/chats/1').to(action: :show, id: 1) }
    it { should route(:post, '/profile/chats').to(action: :create) }
    it { should route(:post, '/profile/chats/1/add').to(action: :add, id: 1) }
    it { should route(:delete, '/profile/chats/1/leave').to(action: :leave, id: 1) }
  end

  describe '#index.json' do
    it 'tst' do
      recipient = create(:user)
      chat = user.chats.create(recipient_id: recipient.id)
      get :index
      expect(assigns(:chats)).to eq([chat])
    end
  end

  describe '#create.json' do
    let(:recipient_id) { user.id.to_s }
    let(:params) { { chat: { recipient_id: recipient_id } } }
    let(:permitted_params) { permit_params! params, :chat }
    before { expect(ChatBuilder).to receive(:new).with(permitted_params, user).and_return(chat) }
    context 'creation success' do
      before { expect(chat).to receive(:save).and_return(true) }
      before { post :create, params: params, format: :json }
      # it { should render_template :create }
    end

    context 'creation fail' do
      before { expect(chat).to receive(:save).and_return(false) }
      before { post :create, params: params, format: :json }
      it { should render_template :errors }
    end
  end

  describe '#show.json' do
    let(:chat) { user.chats.create(recipient_id: random_id) }
    before { get :show, format: :json, params: { id: chat.id } }
    it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(chat).to_json) }
    its(:resource) { should eq chat }
  end

  describe '#join.json' do
    let(:user) { create(:user) }
    let(:chat) { create(:chat) }
    let(:current_user) { create(:user, :with_expected_additional_columns) }
    let(:user_chat_params) { { user_id: current_user.id, chat_id: chat.id } }
    let(:user_chat) { stub_model UserChat }

    before { allow(UserChat).to receive(:find_or_create_by).with(user_chat_params).and_return(user_chat) }

    it do
      UserChat.create(chat_id: chat.id, user_id: user.id)
      post :add, format: :json, params: { id: chat.id }
      expect(UserChat).to have_received(:find_or_create_by).with(user_chat_params)
    end
  end

  describe '#leave.json' do
  end
end
