require 'rails_helper'

RSpec.describe ChatWithinShowSerializer do
  let(:chat) { stub_model Chat, id: 142, recipient_id: 123 }
  let(:serializer) { ChatWithinShowSerializer.new(chat) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }
  let(:serialized_chat) { { 'id' => 142, 'messages' => [], 'users' => [] } }
  it { expect(subject).to eq serialized_chat }
end