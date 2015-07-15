class UserDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def last_login_at
    return "Never" if object.last_login_at.nil?
    object.last_login_at.to_s(:long)
  end

  def last_activity_at
    return "Never" if object.last_activity_at.nil?
    object.last_activity_at.to_s(:long)
  end

end
