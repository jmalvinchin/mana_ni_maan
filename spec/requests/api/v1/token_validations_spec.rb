# Usage example, note lines 9, 12 and 19
# - user should be a valid devise-enabled model factory

require 'rails_helper'

describe "Token Validations", type: :request do
  describe 'signed in' do
    let!(:user) { create :user }
    let!(:auth_helpers_auth_token) { user.create_new_auth_token }

    it 'should respond with success' do
      get '/auth/validate_token' # yes, nothing changed here
      expect(response).to have_http_status(:success)
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get '/auth/validate_token'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

