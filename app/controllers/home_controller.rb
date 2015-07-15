class HomeController < ApplicationController
  def index
    @featured_products = FeaturedProduct.active.decorate
  end
end
