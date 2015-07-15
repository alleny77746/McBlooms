class Price
  CONSUMER = 'consumer'
  DISTRIBUTOR = 'distributor'
  VALID_TARGETS = [CONSUMER, DISTRIBUTOR]

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Alize
  field :amount, type: Money
  field :quantity, type: Integer, default: 1
  field :name, type: String
  field :brief, type: String
  field :target, type: String
  field :size_id, type: String

  embedded_in :product
  has_many :featured_products

  accepts_nested_attributes_for :featured_products, allow_destroy: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :target, presence: true
  validates :size_id, presence: true

  validate :valid_target

  def self.target_collection
    VALID_TARGETS.map { |target| [target.to_s.humanize, target] }
  end

  def size
    return @size ||= product.sizes.find(size_id)
  rescue Mongoid::Errors::DocumentNotFound
    return nil
  end

  def dim_weight
    quantity * size.dim_weight
  end

  #######
  private
  #######


  def valid_target
    errors.add(:target, "#{target} is not a valid target") unless VALID_TARGETS.include?(target)
  end
end
