class PriceDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def size_name
    "#{size.amount} #{size.unit}"
  end

  def name
    return object.name unless object.name.blank?
    "#{quantity} x #{size_name}".html_safe
  end
end
