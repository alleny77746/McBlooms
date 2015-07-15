class CartController < ApplicationController
  respond_to :html, :json
  def show
    authorize! :show, cart
    respond_with cart
  end
  def update
    authorize! :update, cart
    location = cart_path

    cart.user = current_user if cart.user_id.nil? && current_user

    if cart.update_attributes(cart_params)
      if params[:commit] == "Checkout"
        location = cart_checkout_path 
      else
        flash[:notice] = "Your basket was updated successfully"
      end
    end
    respond_with cart, location: location
  end
  
  def destroy
    authorize! :destroy, cart
    flash[:notice] = "Your basket was cleared successfully" if session.delete(:cart_id)
    respond_with cart, location: root_path
  end
  
  #######
  private
  #######
  
  def cart
    current_cart
  end
  
  def cart_params
    params.require(:cart).permit(items_attributes: [:id, :quantity, :_destroy])
  end
end
