require 'active_support/concern'

module Cart::Register
  extend ActiveSupport::Concern

  included do
    attr_accessor :first_name, :last_name, :email, :password
    attr_accessor :checking_out, :registering

    validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, if: :registration_required?
    validates :password, presence: true, confirmation: true, if: :registration_required?
    validate :is_unique_email, if: :registration_required?
  end

  module ClassMethods
    
  end

  def checking_out!
    self.checking_out = true
  end
  def checking_out
    return @checking_out unless @checking_out.nil?
    @checking_out = false
  end
  def checking_out= value
    @checking_out = value
  end
  def checking_out?
    !!checking_out
  end

  def user?
    !!user
  end

  def registration_required?
    checking_out? && user.nil?
  end
  def registering?
    !!registering
  end
  def registering
    @registering = true
  end

  def register_user!
    registering
    self.user = User.create!(registration_attributes) if registration_required? && valid?
    @registering = false
    user
  end

  #######
  private
  #######

  def registration_attributes
    {email: email, password: password, password_confirmation: password_confirmation, first_name:first_name, last_name: last_name}
  end
  
  def is_unique_email
    errors.add(:email, "already exists, try signing in.") if User.where(:email => email).exists?
  end

  
end