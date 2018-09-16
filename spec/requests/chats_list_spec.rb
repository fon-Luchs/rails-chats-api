require 'rails_helper'

RSpec.describe 'ChatsList', type: :request do
  let(:chats) { create_list :chat, 3 }
  let(:user) { create(:user, :with_auth_token, chats: chats) }

  let(:headers) { authorized_headers user.auth_token.value }

  before { get '/profile/chats', params: {}, headers: headers }

  describe do
    it { expect { JSON.parse response.body }.not_to raise_error }

    let(:parsed_response) { JSON.parse response.body }

    it do
      expect(parsed_response).to match([
        {
          'id' => user.chats.first.id,
          'users' => [{}]
        },
        {
          'id' => user.chats.second.id,
          'users' => [{}]
        },
        {
          'id' => user.chats.third.id,
          'users' => [{}]
        }
      ])
    end

    it('returns HTTP Status Code 200') { expect(response).to have_http_status :ok }
  end

  describe do
    before { get '/profile/chats', params: {}, headers: not_authorized_headers }

    it('returns HTTP Status Code 401') { expect(response).to have_http_status :unauthorized }
  end
end
