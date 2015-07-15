class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  field :description, type: String
  field :brief, type: String
  field :start_date, type: Time
  field :end_date, type: Time
  field :position, type: Integer, default: 5

  mount_uploader :image, CategoryImageUploader

  slug :name

  validates :name, presence: true

  has_and_belongs_to_many :products

  default_scope -> {order_by(position: 1)}

end
