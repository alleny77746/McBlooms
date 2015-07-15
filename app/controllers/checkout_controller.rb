class CheckoutController < ApplicationController
  def show
    cart.checking_out!
    build_billing_address(cart)
    build_shipping_address(cart)
  end

  def create
    cart.attributes = cart_params
    if order = cart.checkout
      auto_login(cart.user) unless current_user
      create_new_cart
      flash[:notice] = "Your order was successfully processed"
      redirect_to my_order_path(order)
    else
      render :show
    end
  end

  #######
  private
  #######

  def cart
    @cart ||= current_cart
    @cart.user = current_user unless @cart.user.present?
    @cart
  end

  def build_billing_address(cart)
    cart.build_billing_address(current_user.try(:default_address).try(:attributes)) if cart.billing_address.nil?
  end
  def build_shipping_address(cart)
    cart.build_shipping_address if cart.shipping_address.nil?
  end

  def cart_params
    params.require(:cart).permit(:email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      credit_card_attributes:
        [:name,
         :number,
         :month,
         :year,
         :brand,
         :verification_value],
      billing_address_attributes: [
        :street,
        :street2,
        :city,
        :province,
        :country,
        :postal_code],
      shipping_address_attributes: [
        :street,
        :street2,
        :city,
        :province,
        :country,
        :postal_code]
    )
  end
end
