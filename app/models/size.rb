class Size
  include Mongoid::Document
  field :amount, type: BigDecimal
  field :unit, type: String
  field :dim_weight, type: Integer, default: 1

  embedded_in :product

  validates :amount, presence: true
  validates :unit, presence: true
  validates :dim_weight, presence: true, numericality: {only_integer: true, greater_than: 0}

  def to_s
    "#{amount} #{unit}"
  end
end
