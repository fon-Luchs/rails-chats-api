require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  it { should be_a ApplicationController }

  let(:chat) { stub_model Chat}
  let(:random_id) { FFaker::Random.rand(10..1000) }
  let(:user) { stub_model User, id: 1321 }
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
      let(:recipient_id) { user.id }
      let(:params) { { chat: { recipient_id: recipient_id.to_json } } }
      let(:permitted_params) { permit_params! params, :chat }
      let(:chat_builder) { ChatBuilder.new(permitted_params, user) }
    before do
      expect(ChatBuilder).to receive(:new).with(permitted_params, user).and_return(chat_builder) 
      expect(chat_builder).to receive(:build).and_return(chat)
    end

    context 'creation success' do
      before { expect(chat).to receive(:save).and_return(true) }
      before { post :create, params: params, format: :json }
      it { expect(controller.params.permitted?).to eq(true) }
      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end

    context 'creation fail' do
      before { expect(chat).to receive(:save).and_return(false) }
      before { post :create, params: params, format: :json }
      it { should render_template :errors }
    end
  end

  describe '#show.json' do
    subject { create(:chat, recipient_id: random_id) }
    before { get :show, format: :json, params: { id: subject.id } }
    it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(subject).to_json) }
    it(:resource) { should eq subject }
  end

  describe '#join.json' do
    it do
     
    end
  end

  describe '#leave.json' do
  end
end
