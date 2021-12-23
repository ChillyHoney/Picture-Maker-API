require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.save!
    saved_file = @user.pictures.attach(io: File.open("./storage/test.jpg"), filename: "test.jpg", content_type: "image/jpg")
  end

  describe "Upload picture" do
    context "with a valid picture" do    

      it "saves the picture" do        
        expect(@user.pictures).to be_attached
      end

    end
  end
end