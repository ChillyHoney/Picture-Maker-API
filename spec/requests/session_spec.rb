require "rails_helper"

RSpec.describe "Session", :type => :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.confirm
    @sign_in_url = '/api/v1/auth/sign_in'
    @sign_out_url = '/api/v1/auth/sign_out'
    @update_url = '/api/v1/auth'
    @login_params = {
      email: @user.email,
      password: @user.password
    }
    @update_params = {
      email: @user.email,
      password: @user.password
    }
  end

  describe 'POST /api/v1/auth/sign_in' do

    context 'when login params is valid' do
      before do
        post @sign_in_url, params: @login_params, as: :json
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns access-token in authentication header' do
        expect(response.headers['access-token']).to be_present
      end

      it 'returns client in authentication header' do
        expect(response.headers['client']).to be_present
      end

      it 'returns expiry in authentication header' do
        expect(response.headers['expiry']).to be_present
      end

      it 'returns uid in authentication header' do
        expect(response.headers['uid']).to be_present
      end
    end
  end

  context 'when login params is invalid' do
    before { post @sign_in_url }

    it 'returns unathorized status 401' do
      expect(response.status).to eq 401
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    before do
      post @sign_in_url, params: @login_params, as: :json
      @headers = {
      'access-token' => response.headers['access-token'],
      'client' => response.headers['client'],
      'uid' => response.headers['uid']
      }
    end

    it 'returns status 200' do
      delete @sign_out_url, headers: @headers
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH /api/v1/auth' do
    before do
      post @sign_in_url, params: @login_params, as: :json
      @headers = {
        'access-token' => response.headers['access-token'],
        'client' => response.headers['client'],
        'uid' => response.headers['uid']
      }
    end

    it 'should update user email' do
      patch "/api/v1/auth/", params: @update_params, headers: @headers
      expect(response).to have_http_status(:success)
    end

    it 'when invalid data to change' do
      patch @update_url, headers: @headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "when can't find user" do
      patch @update_url, params: @update_params
      expect(response).to have_http_status(:not_found)
    end
  end
end
