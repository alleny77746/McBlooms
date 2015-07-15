class FavoritesController < ApplicationController
  before_action :require_login
  respond_to :html, :json, :js
  def index
    @products = current_user.favorite_products
    respond_with @products
  end
  def update
    current_user.favorite(product)
    respond_with product, location: root_path
  end
  def destroy
    current_user.remove_favorite(product)
    respond_with product, location: root_path
  end
  #######
  private
  #######

  def product
    @product = Product.find(params[:id])
  end
  helper_method :product
end
