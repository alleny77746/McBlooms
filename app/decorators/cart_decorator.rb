class CartDecorator < Draper::Decorator
  delegate_all

  def items
    object.items.decorate
  end

end
