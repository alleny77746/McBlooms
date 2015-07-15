module FavoritesHelper
  def favorite_btn_for(product, options = {})
    return unless current_user
    klass = options.delete(:class).to_s.split(" ")
    klass << "favorite-btn btn"
    name = "Mark as Favorite"
    if current_user.favorite_product_ids.include? product.id
      options.reverse_merge! data: { method: "DELETE", remote: true },
                             type: :warning, icon: 'thumbs-down'
      name = "Remove from Favorites"
    else
      options.reverse_merge! data: { method: "PUT", remote: true },
                             type: :success,
                             icon: 'thumbs-up'
    end
    options.merge!(class: klass.join(" "))
    link_to_btn name, my_profile_favorite_path(id: product.to_param), options
  end
end