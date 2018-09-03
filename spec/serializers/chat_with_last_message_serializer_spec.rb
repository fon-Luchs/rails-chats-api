require 'rails_helper'

RSpec.describe ChatWithLastMessageSerializer do
  let(:chat) { stub_model Chat, id: 142, recipient_id: 123, last_message: 'Hello test' }
  let(:serializer) { ChatWithLastMessageSerializer.new(chat) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }
  let(:serialized_chat) { { 'id' => 142, 'last_message' => 'Hello test', 'users' => [] } }
  it { expect(subject).to eq serialized_chat }
end