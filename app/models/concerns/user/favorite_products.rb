class User
  module FavoriteProducts
    extend ActiveSupport::Concern

    included do
      has_and_belongs_to_many :favorite_products, class_name: "Product", inverse_of: nil
    end

    module ClassMethods

    end

    # instance methods...
    def favorite(product)
      self.favorite_products << product
    end

    def remove_favorite(product)
      return if product.nil?
      self.favorite_products.delete(product)
    end
  end
end