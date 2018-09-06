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
    let(:params) { { chat: { recipient_id: user.id.to_json } } }
    let(:permitted_params) { permit_params! params, :chat }
    before do
      expect(ChatBuilder).to receive(:new).with(permitted_params, user) do
        double.tap do |chat_builder|
          expect(chat_builder).to receive(:build).and_return(chat)
        end
      end
    end

    context 'creation success' do
      before { expect(chat).to receive(:save).and_return(true) }
      before { post :create, params: params, format: :json }
      let(:recipient_id) { user.id }
      let(:params) { { chat: { recipient_id: recipient_id.to_json } } }
      let(:permitted_params) { permit_params! params, :chat }
      it { expect(permitted_params.permitted?).to eq(true) }
      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end

    context 'creation fail' do
      subject{ chat.errors }
      before { expect(chat).to receive(:save).and_return(false) }
      before { subject.add(:base, 'error') }
      before { post :create, params: params, format: :json }
      it { expect(response.body).to eq(subject.messages.to_json) }
    end
  end

  describe '#show.json' do
    subject { create(:chat, recipient_id: random_id) }
    before { get :show, format: :json, params: { id: subject.id } }
    it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(subject).to_json) }
    it(:resource) { should eq subject }
  end

  describe '#join.json' do
    let(:params)  { { user_id: user.id } }
    let(:finded_user_chat) { stub_model UserChat, user: user, chat: chat }
    before do
      expect(Chat).to receive(:find).with(chat.id.to_s) do
        double.tap do |chat|
          expect(chat).to receive(:user_chats) do
            double.tap do |user_chat|
              expect(user_chat).to receive(:find_or_create_by)
                .with(params).and_return(finded_user_chat)
            end
          end
        end
      end
    end

    context 'join success' do
      before { post :add, format: :json, params: { id: chat.id } }
      before { expect(finded_user_chat).to receive(:save).and_return(true) }
      it { expect(response.body).to eq(ChatSerializer.new(chat).to_json) }
    end

    context 'join fail' do
      before { post :add, format: :json, params: { id: chat.id } }
      before { expect(finded_user_chat).to receive(:save).and_return(false) }
      it { should render_template :errors }
    end
  end

  describe '#leave.json' do
  end
end
