module CartHelper
  def cart_quantity
    return 0 unless current_cart
    current_cart.count
  end

  def current_cart
    Cart.find(session[:cart_id]) if session[:cart_id]
  end

  def display_cart_quantity
    return unless cart_quantity > 0
    "(#{cart_quantity})"
  end

  def default_icon(address)
    return "" unless address.default?
    fa_icon :home
  end

  def select_prefillable_address
    return "" unless current_user && !current_user.addresses.empty?
    content_tag(:div, class: "row") do
      render partial: "address_selector", collection: current_user.addresses.decorate, as: :address
    end
  end
end