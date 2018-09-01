require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context do
    let(:user) { stub_model User }
    before{ sign_in user }
    describe '#show.json' do
      before { get :show, format: :json, params: { id: user.id } }
      # it { should render_template :show }
      its(:resource) { should eq user }
    end
  end
end