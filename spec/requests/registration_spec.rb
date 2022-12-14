require "rails_helper"

RSpec.describe "Registration", :type => :request do
  before(:each) do
    @confirmation_post = post "/api/v1/auth/confirmation/", :params => @signup_params    
    @sign_up_url = '/api/v1/auth/'
    @signup_params = {
      email: 'user@example.com',
      username: 'tescik123',
      password: '12345678'
    }
  end

  describe 'Email registration method' do
    describe 'POST /api/v1/auth/' do
      
      context 'when signup params is valid' do
        before do
          post @sign_up_url, params: @signup_params
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns status success' do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['status']).to eq('success')
        end

        it 'creates new user' do
          expect{ post @sign_up_url,
            params: @signup_params.merge({ email: 'test@example.com', username: 'user123' })
          }.to change(User, :count).by(1)
        end    

        it 'sends email verification after signup' do
          expect(Devise.mailer.deliveries.count).to eq 1
          expect(response).to have_http_status(200)
        end
      end
               
      context 'when signup params is invalid' do
        before { post @sign_up_url }

        it 'returns unprocessable entity 422' do
          expect(response.status).to eq 422
        end
      end
    end
  end
end
