require 'rails_helper'

RSpec.describe MessageSerializer do
  let(:user) { create(:user, name: 'bot') }
  let(:message) { stub_model Message, id: 2, body: 'test', user: user }
  let(:serializer) { MessageSerializer.new(message) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_message) { { 'id'=>2, 'body'=>'test', 'user_name'=>'bot' } }
  subject{ JSON.parse(serialization.to_json) }
  it { expect(subject).to eq serialized_message }
end