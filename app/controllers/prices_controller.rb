class PricesController < ApplicationController
  respond_to :html, :json
  before_action :product
  before_action :price, only: [:show, :edit, :update, :destroy]
  helper_method :category, :product, :price

  def index
    @prices = product.prices.all.decorate
    respond_with @prices
  end

  def show
    respond_with @price
  end

  def new
    @price = product.prices.new
    respond_with @price
  end

  def edit
    respond_with @price
  end

  def create
    @price = product.prices.new(price_params)
    flash[:notice] = 'Price was successfully created.' if @price.save
    respond_with @price, location: [category, product]
  end

  def update
    flash[:notice] = 'Price was successfully updated.' if @price.update_attributes(price_params)
    respond_with @price, location: [category, product]
  end

  def destroy
    price.destroy
    respond_with @price, location: [product]
  end

  #######
  private
  #######


  # Use callbacks to share common setup or constraints between actions.
  def price
    return if params[:id].nil?
    @price = product.prices.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def price_params
    params.require(:price).permit(
      :size_id,
      :quantity,
      :amount,
      :name,
      :brief,
      :target,
      featured_products_attributes: [
        :id,
        :start_time,
        :end_time,
        :importance,
        :_destroy
      ]
    )
  end

  def product
    return if params[:product_id].nil?
    @product ||= Product.find(params[:product_id])
  end

  def category
    return if params[:category_id].nil?
    @category ||= Category.find(params[:category_id])
  end
end
