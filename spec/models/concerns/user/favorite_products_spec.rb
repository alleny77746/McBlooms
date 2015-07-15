require 'spec_helper'

describe User::FavoriteProducts do
  class FavoriteProductTest
    include Mongoid::Document
    include User::FavoriteProducts
  end

  let(:product) { build :product }
  subject(:user) { FavoriteProductTest.new() }
  it "responds to favorite_products" do
    expect(user.favorite_products).to be_empty
  end

  context 'favorite(product)' do
    it "adds to favorite_products" do
      expect{user.favorite(product)}.to change{user.favorite_product_ids.count}.by(1)
    end
    it "doesn't add if product is nil" do
      expect{user.favorite(nil)}.to_not change{user.favorite_product_ids.count}
    end
  end
  context "remove_favorite(product)" do
    before(:each) do
      user.favorite(product)
    end
    it "removes the product" do
      expect { user.remove_favorite(product) }.to change{user.favorite_product_ids.count}.by(-1)
    end
    it "doesn't do anything if product is nil" do
      expect { user.remove_favorite(nil) }.to_not change{user.favorite_product_ids.count}
    end
  end
end