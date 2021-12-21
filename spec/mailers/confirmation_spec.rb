require "rails_helper"

RSpec.describe "Confirmation", :type => :mailer do
  describe "email" do

    include EmailSpec::Helpers
    include EmailSpec::Matchers
    include Rails.application.routes.url_helpers

    context 'when signup params is valid -' do
      before do
        @user = FactoryBot.create(:user)
          @email = @user.send_confirmation_instructions
        end

      it "should save a user" do
        expect(@user).to be_valid
      end

      it 'should have access to URL' do
        expect { '/api/v1/auth/confirmation/' }.not_to raise_error
      end

      it 'should send an email' do
        expect(Devise.mailer.deliveries.count).to eq 1
	    end

      it 'should deliver mail from proper adress' do
        expect(@email).to deliver_from("do-not-reply@picturemaker.com")
      end      

      it 'should deliver email to user' do
        expect(@email).to deliver_to(@user.email)
      end

      it 'should have the correct subject' do
        expect(@email).to have_subject('Instrukcja potwierdzania')
      end

      it "should contain the proper body text" do
        expect(@email).to have_body_text(/Witaj #{@user.email}!/)
      end

      it 'should contain a link to the confirmation link' do
        expect(@email).to have_body_text(/confirmation_token=#{@user.confirmation_token}/)
      end
  	end
  end
end 
