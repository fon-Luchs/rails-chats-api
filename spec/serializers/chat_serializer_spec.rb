require 'rails_helper'

RSpec.describe ChatSerializer do
  let(:chat) { stub_model Chat, id: 142, recipient_id: 123 }
  let(:serializer) { ChatSerializer.new(chat) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }
  let(:serialized_chat) { { 'id' => 142, 'users' => [] } }
  it { expect(subject).to eq serialized_chat }
end