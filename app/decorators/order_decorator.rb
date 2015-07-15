class OrderDecorator < Draper::Decorator
  delegate_all

  def number
    object.order_number
  end

  def purchased_at
    object.created_at.try(:to_s, :long) || "Unknown"
  end

  def items
    object.items.decorate
  end
end
