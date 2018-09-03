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
    it do
      chat = user.chats.create(recipient_id: random_id)
      get :index
      expect(response).to have_http_status(200)
      expect(assigns(:chats)).to eq([chat])
    end
  end

  describe '#create.json' do
    let(:recipient_id) { user.id.to_s }
    let(:params) { { chat: { recipient_id: recipient_id } } }
    let(:permitted_params) { permit_params! params, :chat }
    let(:chat_builder) { ChatBuilder.new(permitted_params, user) }
    before { expect(ChatBuilder).to receive(:new).with(permitted_params, user).and_return(chat_builder) }

    context 'creation success' do
      before { expect(chat).to receive(:save).and_return(true) }
      before { post :create, params: params, format: :json }
      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
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
    subject { ChatsController.new }
    it do
      allow(subject).to receive(:set_chat).and_return(chat)
    end
  end

  describe '#leave.json' do
  end
end
