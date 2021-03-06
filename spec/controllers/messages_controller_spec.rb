require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user, :with_auth_token, :with_expected_additional_columns) }

  let(:chat) { stub_model Chat, id: 15 }

  before { sign_in user }

  describe '#create' do
    subject { stub_model Message }

    let(:params) { { message: { body: 'test msg', user_id: user.id } } }

    let(:permitted_params) do
      permit_params! params, :message
    end

    let(:request_params) do
      { chat_id: chat.id, message: { body: 'test msg', user_id: user.id } }
    end

    before { expect(Chat).to receive(:find).with(chat.id.to_s).and_return(chat) }

    before do
      expect(chat).to receive(:messages) do
        double.tap { |a| expect(a).to receive(:new).with(permitted_params).and_return(subject) }
      end
    end

    context 'create is success' do
      before { expect(subject).to receive(:save).and_return(true) }

      before { expect(chat).to receive(:chat_without_message?) }

      before { post :create, params: request_params, format: :json }

      it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(chat).to_json) }
    end

    context 'create is fall' do
      before { expect(subject).to receive(:save).and_return(false) }

      before { subject.errors.add(:base, 'error') }

      before { post :create, params: request_params, format: :json }

      it { expect(response.body).to eq(subject.errors.messages.to_json) }
    end
  end

  describe '#index' do
    let(:msg)        { chat.messages.create(user_id: user.id, body: 'Hi)') }

    let(:msg_newest) { chat.messages.create(user_id: user.id, body: 'Guys') }

    let(:PER_PAGE_SIZE) { 30 }

    before { expect(Chat).to receive(:find).with(chat.id.to_s).and_return(chat) }

    before { expect(chat).to receive(:messages).and_return(chat.messages).at_most(4).times }

    before do
      expect(chat.messages).to receive_message_chain(:order, :paginate)
        .with('created_at DESC').with(page: nil, per_page: 30)
        .and_return(subject)
    end

    before { get :index, params: { chat_id: chat.id }, format: :json }

    it { expect(response.body).to eq(ChatWithinShowSerializer.new(chat).to_json) }
  end

  describe 'routes test' do
    it { should route(:get, '/profile/chats/2/messages').to(action: :index, chat_id: 2) }

    it { should route(:post, '/profile/chats/2/messages').to(action: :create, chat_id: 2) }
  end
end
