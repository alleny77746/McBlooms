class Ingredient
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  field :description, type: String
  field :key, type: Boolean, default: false

  slug :name

  has_and_belongs_to_many :products

  mount_uploader :image, IngredientImageUploader

  validates :name, presence: true
end
