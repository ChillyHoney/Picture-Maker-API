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

      it "rejecting invalid format" do
        is_expected.to validate_content_type_of(:pictures).rejecting('text/plain', 'text/xml', 'image/gif')
      end

      it "allowing valid size" do
        is_expected.to validate_size_of(:pictures).less_than_or_equal_to(5.megabytes)
      end
    end
  end
end