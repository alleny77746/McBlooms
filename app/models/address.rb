class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :street, type: String
  field :street2, type: String
  field :city, type: String
  field :province, type: String
  field :country, type: String
  field :postal_code, type: String
  field :default, type: Mongoid::Boolean, default: false

  validates :street, presence: true
  validates :city, presence: true
  validates :province, presence: true
  validates :country, presence: true
  validates :postal_code, presence: true

  embedded_in :addressable, polymorphic: true

  before_save :ensure_one_default
  after_destroy :ensure_default
  before_create :ensure_default

  #######
  private
  #######

  def ensure_one_default
    return true unless addressable.respond_to? :addresses
    if default_changed? && default?
      addressable.addresses.not_in(:_id => id).update_all({default: false})
    end
    true
  end

  def ensure_default
    return true unless addressable.respond_to? :addresses
    if addressable.addresses.where(:default => true).count == 0
      addressable.addresses.first.update_attribute(:default, true) if addressable.addresses.count > 0
      self.default = true if self.persisted?
    end
    true
  end
end
