require 'rails_helper'

RSpec.describe UserShowSerializer do
  let(:user) { stub_model User, id: 2, name: 'test' }
  let(:serializer) { UserShowSerializer.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }
  let(:serialized_user) { { 'id'=> 2, 'name'=> 'test' } }
  it { expect(subject).to eq serialized_user }
end