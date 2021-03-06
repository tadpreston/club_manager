require 'spec_helper'

describe HomeController do

  describe "GET 'index' with no authentication" do
    it "should redirect to login" do
      get 'index'
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index' authenticated" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
