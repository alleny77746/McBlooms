class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Alize

  mount_uploader :image, ProductImageUploader

  field :sku, type: String
  field :name, type: String
  field :brief, type: String
  field :description, type: String
  field :start_date, type: Time
  field :end_date, type: Time

  slug :name

  validates :sku, presence: true, uniqueness: true
  validates :name, presence: true

  has_and_belongs_to_many :categories
  embeds_many :sizes
  embeds_many :prices
  has_many :featured_products, dependent: :delete_all

  has_and_belongs_to_many :ingredients

  accepts_nested_attributes_for :sizes,
                                reject_if: :all_blank,
                                allow_destroy: true

  def to_param
    slug
  end

  def list_image
    image.url(:list)
  end

end
