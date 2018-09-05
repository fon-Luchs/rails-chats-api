require 'rails_helper'

RSpec.describe ChatBuilder do
  let(:user) { stub_model User, id: 123 }
  xit{ expect(ChatBuilder).to recevie(:initialize).with() }
end