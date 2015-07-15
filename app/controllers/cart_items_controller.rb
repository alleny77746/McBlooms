class CartItemsController < ApplicationController
  respond_to :html, :json
  
  def update
    if product && price
      cart_item = current_cart.add(price, params[:quantity] || 1)
      respond_with cart_item, location: cart_path
    else
      flash[:error] = "Unable to find your product, please try again"
      redirect_to :back
    end
  end
  
  def destroy
    cart_item = currect_cart.remove(params[:price_id])
    respond_with cart_item, location: cart_path
  end
  
  #######
  private
  #######
  def price
    @price ||= product.prices.find(params[:price_id])
  end
  def product
    @product ||= Product.find(params[:product_id])
  end
end
