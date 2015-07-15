require 'spec_helper'

describe FavoritesController, type: :controller do
  let(:user) { build :user }
  before(:each) do
    login_user(user)
  end
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
