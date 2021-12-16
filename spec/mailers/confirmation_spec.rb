require "rails_helper"

RSpec.describe "Confirmation", :type => :mailer do
	
	describe "email" do

    include EmailSpec::Helpers
    include EmailSpec::Matchers
    include Rails.application.routes.url_helpers

		context 'when signup params is valid -' do      
			before do
				@user = FactoryBot.create(:user)
				@user.send_confirmation_instructions				
			end

			it "should save a user" do				
				expect(@user).to be_valid
			end

			it 'should have access to URL' do
				expect { "/api/v1/auth/confirmation/" }.not_to raise_error
			end

			it 'should send an email' do
				expect(Devise.mailer.deliveries.count).to eq 1
			end

		end
	end
end 