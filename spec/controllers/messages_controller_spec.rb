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
    before do
      expect(Chat).to receive(:find).with(chat.id.to_s) do
        double.tap do |chat|
          expect(chat).to receive_message_chain(:messages, :new)
            .with(no_args).with(permitted_params).and_return(subject)
        end
      end
    end

    context 'message create is success' do
      before{ expect(subject).to receive(:save).and_return(true) }
      before{ post :create, params: request_params, format: :json }

      it { expect(chat).to receive(:chat_without_massage?) }
      it { expect(response.body).to eq(ChatWithLastMessageSerializer.new(chat).to_json) }
    end

    context 'message create is fail' do
      before  { subject.errors.add(:base, 'error') }
      before{ expect(subject).to receive(:save).and_return(false) }
      before{ post :create, params: request_params, format: :json }

      it { expect(response.body).to eq(subject.errors.messages.to_json) }
    end
  end

  describe '#index' do
    subject { Message.order('created_at DESC') }
    let(:msg)        { chat.messages.create(user_id: user.id, body: 'Hi)') }
    let(:msg_newest) { chat.messages.create(user_id: user.id, body: 'Guys') }

    before do
      expect(Chat).to receive(:find).with(chat.id.to_s).and_return(chat)
    end

    it 'test pagination' do
      expect(subject.paginate(page: nil, per_page: 30)).to eq([msg_newest, msg])
    end

    it 'test serializer' do
      get :index, params: { chat_id: chat.id }, format: :json
      expect(response.body).to eq(ChatWithinShowSerializer.new(chat).to_json)
    end
  end
end
