require 'rails_helper'

RSpec.describe 'MessageCreate', type: :request do
  let!(:chat) { create(:chat) }
  let!(:user) { create(:user, :with_auth_token, :with_expected_additional_columns) }
  let(:headers) { authorized_headers user.auth_token.value }
  let(:params) { { message: { body: 'lol', user_id: user.id } }.to_json }

  before { post "/profile/chats/#{chat.id}/messages", params: params, headers: headers }

  describe do
    it { expect { JSON.parse response.body }.not_to raise_error }

    let(:parsed_response) { JSON.parse response.body }

    it do
      expect(parsed_response).to match(
        {
          'id' => chat.id,
          'last_message' => 'lol',
          'users' => []
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
