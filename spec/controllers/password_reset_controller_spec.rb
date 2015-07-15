require 'spec_helper'

describe PasswordResetController, type: :controller do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  describe "GET 'edit'" do
    let(:user) { build :user }
    let(:token) { "1234" }
    it "returns http success" do
      User.stubs(:load_from_reset_password_token).with(token).returns(user)
      get 'edit', id: token
      expect(response).to be_success
    end
  end

end
