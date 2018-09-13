require 'rails_helper'

RSpec.describe 'ChatBuild', type: :request do
  let(:user) { create(:user, :with_auth_token) }
  let(:headers) { authorized_headers user.auth_token.value }
  let(:params) { { chat: { recipient_id: user.id.to_s } }.to_json }

  before { post '/profile/chats', params: params, headers: headers }

  describe do
    it { expect { JSON.parse response.body }.not_to raise_error }

    let(:parsed_response) { JSON.parse response.body }

    it do
      expect(parsed_response).to match(
        {
          'id' => Chat.last.id,
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
