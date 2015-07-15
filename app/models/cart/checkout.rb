require 'active_support/concern'

module Cart::Checkout
  extend ActiveSupport::Concern
  #Requires access to methods in Cart::Register

  included do
    attr_accessor :checking_out
    attr_writer :credit_card

    validate :validate_credit_card, if: :checking_out?
    validate :check_user, if: :checking_out?
    validate :check_already_processed, if: :checking_out?
  end

  module ClassMethods

  end

  def checkout
    checking_out!
    self.user = register_user!
    if valid?
      if process_payment
        order.paid!
        order.save
        return order
      end
    end
    false
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new
  end

  def credit_card_attributes=attributes
    @credit_card = ActiveMerchant::Billing::CreditCard.new(attributes)
  end


  #######
  private
  #######
  def gateway
    ActiveMerchant::Billing::OrbitalGateway.new(CREDIT_CARD_ACCOUNT_INFO)
  end

  def purchase(amount, order_id)
    gateway.purchase(amount, credit_card, :order_id => order_id)
  end

  def process_payment
    begin
      amount = total
      amount = 1 if Rails.env.development?
      order_id = Time.now.to_f
      # Authorize for the amount
      response = purchase((amount * 100).to_i, order_id)
      if response.success?
        self.checking_out = false
        self.order = Order.build_from(self)
        order.order_number = order_id
        order.save!
        # create_transaction(order, total, response,credit_card)
        return order
      end
    end

  end

  def check_user
    # errors.add(:base, "You must first sign in before you can checkout") unless user.present? || registering?
    true
  end

  def validate_credit_card
    unless credit_card.valid?
      errors.add(:base, 'Credit card is invalid')
      credit_card.errors.add(:name, "Full name is required") unless credit_card.errors[:first_name].empty? && credit_card.errors[:last_name].empty?
      return false
    end
    true
  end

  def check_already_processed
    errors.add(:base, "Cart has already been processed") if order.present?
  end

end