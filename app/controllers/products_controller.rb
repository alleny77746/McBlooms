class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    return redirect_to(category) if category
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show

  end

  # GET /products/new
  def new
    @product = (category ? category.products : Product)
                 .new(category_ids: params[:category_ids])
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = (category ? category.products : Product).new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          redirect_to [@category, @product],
                      notice: 'Product was successfully created.'
        end
        format.json do
          render action: 'show', status: :created, location: @product
        end
      else
        format.html { render action: 'new' }
        format.json do
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to [@category, @product],
                      notice: 'Product was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @product.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to @category || products_url }
      format.json { head :no_content }
    end
  end

  #######
  private
  #######

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = if params[:category_id]
                 category.products.find(params[:id]).decorate
               else
                 Product.find(params[:id]).decorate
               end
  end

  def category
    @category ||= Category.find(params[:category_id]) if params[:category_id]
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def product_params
    params.require(:product)
      .permit(:sku,
              :name,
              :description,
              :start_date,
              :end_date,
              :image,
              :remove_image,
              :brief,
              { category_ids: [] },
              { ingredient_ids: [] },
              sizes_attributes: [:id,
                                 :amount,
                                 :unit,
                                 :dim_weight,
                                 :_destroy]
            )
  end
end
