class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include User::FavoriteProducts

  VALID_PERMISSIONS = {
    '10' => "consumer",
    '20' => "distributor",
    '99' => "administrator"
  }

  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation

  field :first_name, type: String
  field :last_name, type: String
  field :permission, type: Integer, default: 10
  field :mailing_list, type: Boolean, default: false

  # Sorcery Fields (added by itself, no need to include them)
  # field :email, type: String
  # field :crypted_password, type: String
  # field :activation_state, type: String
  # field :activation_token, type: String
  # field :activation_token_expires_at, type: DateTime
  # field :reset_password_token, type: String
  # field :reset_password_token_expires_at, type: DateTime
  # field :reset_password_email_sent_at, type: DateTime
  # field :failed_logins_count, type: Integer
  # field :lock_expires_at, type: DateTime
  # field :unlock_token, type: String
  # field :last_login_at, type: DateTime
  # field :last_activity_at, type: DateTime

  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates_presence_of :password, on: :create

  before_save :check_default_address
  after_save :clear_passwords
  slug :name

  embeds_many :addresses, as: :addressable, cascade_callbacks: true
  has_many :carts
  has_many :orders

  class << self
    def permission_collection
      VALID_PERMISSIONS.map{|k, v| [v, k]}
    end
  end

  def name
    [first_name, last_name].join(" ")
  end

  def permission_name
    VALID_PERMISSIONS[permission.to_s] || VALID_PERMISSIONS['10']
  end

  def admin?
    permission >= 99
  end

  def distributor?
    permission == 20
  end

  def consumer?
    permission <= 10
  end

  def default_address
    addresses.where(default: true).first
  end

  #######
  private
  #######

  def check_default_address
    return unless addresses.size > 0
    return if default_address
    addresses.first.default = true
  end

  def clear_passwords
    self.password = self.password_confirmation = nil
  end
end
