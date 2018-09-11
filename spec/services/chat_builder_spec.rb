require 'rails_helper'

RSpec.describe ChatBuilder do
  let(:user) { stub_model User }
  let(:params) { { recipient_id: user.id } }
  let(:chat_builder) { ChatBuilder.new(params, user) }

  describe 'initialize' do
    subject { chat_builder }

    it { expect(subject.instance_variable_get(:@params)).to eq(params) }
    it { expect(subject.instance_variable_get(:@current_user)).to eq(user) }
  end

  describe 'build' do
    subject { stub_model Chat }


    before do
      expect(chat_builder).to receive(:build)
    end

    it do
      expect(User).to receive(:find).with(params[:recipient_id]).and_return(user)
      expect(Chat).to receive(:new).and_return(subject)
    end
  end

  describe 'recipient' do
  end
end
