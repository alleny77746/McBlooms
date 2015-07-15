describe FavoritesHelper, type: :helper do
  context 'favorite_btn_for' do
    let(:product) { create :product }
    let(:user) { build :user }
    subject(:result) { helper.favorite_btn_for(product) }
    it "returns nil if no current_user" do
      helper.stubs(:current_user)
      expect(subject).to be_nil
    end
    context 'with current_user' do
      before(:each) do
        helper.stubs(:current_user).returns user
      end
      it "returns favorite link" do
        expect(result).to have_link("Mark as Favorite",
                                    href: my_profile_favorite_path(id: product.to_param))
        expect(result).to have_selector("[data-method='PUT']")
      end
      it "has a class of .favorite-btn" do
        expect(result).to have_selector(".favorite-btn")
      end
      it "returns a remove link" do
        helper.current_user.stubs(:favorite_product_ids).returns [product.id]
        expect(result).to have_link("Remove from Favorites",
                                    href: my_profile_favorite_path(id: product.to_param))
        expect(result).to have_selector("[data-method='DELETE']")
      end
    end

  end
end