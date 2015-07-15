class FeaturedProductDecorator < Draper::Decorator
  include AlizeHelper
  delegate_all

  def product_slug
    product_fields[:_slugs].first
  end

  def price_amount
    Money.new((price_fields.fetch("amount") { {'cents' => 0} }).fetch('cents'))
  end
end