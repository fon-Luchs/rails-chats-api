require 'rails_helper'

RSpec.describe ProfileShowSerialize do
  let(:user) { stub_model User, id: 2, name: 'test', email: 'email' }
  let(:serializer) { ProfileShowSerialize.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  subject { JSON.parse(serialization.to_json) }
  let(:serialized_user) { { 'email'=>'email' } }
  it { expect(subject).to eq serialized_user }
end