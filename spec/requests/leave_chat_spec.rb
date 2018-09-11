require 'rails_helper'

RSpec.describe 'LeaveChat', type: :request do
  let!(:chat) { create(:chat) }
  let!(:user) { create(:user, :with_auth_token) }
  let(:users) { create_list(:user, 2, :with_auth_token) }
  let(:headers) { authorized_headers user.auth_token.value }
  let(:params) { { chat: { recipient_id: user.id.to_s } }.to_json }

  before do
    chat.users << users.first
    chat.users << users.second
    delete "/profile/chats/#{chat.id}/leave", params: params, headers: headers 
  end

  describe do
    it { expect { JSON.parse response.body }.not_to raise_error }

    let(:parsed_response) { JSON.parse response.body }

    it do
      expect(parsed_response).to match(
        {
          'id' => chat.id,
          'users' => [{}, {}]
        }
      )
    end

    it('returns HTTP Status Code 200') { expect(response).to have_http_status :ok }
  end

  describe do
    before { get '/profile/chats', params: {}, headers: not_authorized_headers }

    it('returns HTTP Status Code 401') { expect(response).to have_http_status :unauthorized }
  end
end
