require 'rails_helper'

RSpec.describe ChatBuilder do
  let(:current_user)   { stub_model User }

  let(:recipient_user) { stub_model User }

  let(:params)         { { recipient_id: recipient_user.id } }

  let(:chat_builder)   { ChatBuilder.new(params, current_user) }

  let(:chat)           { stub_model Chat }

  describe '.initialize' do
    it { expect(chat_builder.instance_variable_get(:@params)).to eq(params) }

    it do
      expect(chat_builder.instance_variable_get(:@current_user))
        .to eq(current_user)
    end
  end

  describe '.build' do
    before { expect(Chat).to receive(:new).with(params).and_return(chat) }

    before do
      expect(User).to receive(:find)
        .with(params[:recipient_id])
        .and_return(recipient_user)
    end

    before { add_user_in_chat current_user }

    before { add_user_in_chat recipient_user }

    it { expect(chat_builder.build).to eq(chat) }
  end

  describe '.recipient' do
    before do
      expect(User).to receive(:find)
        .with(params[:recipient_id])
        .and_return(recipient_user)
    end

    it { expect(recipient_user).to eq(User.find(params[:recipient_id])) }
  end

  def add_user_in_chat(user)
    expect(chat).to receive(:users) do
      double.tap { |a| expect(a).to receive(:<<).with(user) }
    end
  end
end
