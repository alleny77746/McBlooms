class ItemDecorator < Draper::Decorator
  delegate_all

  def image
    product.image
  end

  def product
    @product ||= object.product.decorate
  end

  def product_name
    product.name
  end

  def name
    "#{product.name} - #{price.name}".html_safe
  end

  def price
    @price ||= object.price.decorate
  end

end
