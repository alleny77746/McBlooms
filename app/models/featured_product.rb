class FeaturedProduct
  include Mongoid::Document
  include Mongoid::Alize

  field :start_time, type: Time
  field :end_time, type: Time
  field :importance, type: Integer, default: 5

  belongs_to :product
  belongs_to :price

  before_validation :set_product_id

  scope :active, (lambda do
    where(start_time: { '$lte' => DateTime.now },
          end_time: { '$gte' => DateTime.now })
  end)

  alize :product, :sku, :name, :brief, :_slugs, :list_image
  alize :price, :name, :amount

  #######
  private
  #######

  def set_product_id
    return unless product_id.blank?
    self.product_id = Product.where('prices._id' => price_id).pluck('_id').first
  end
end
