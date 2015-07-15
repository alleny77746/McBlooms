class AddressDecorator < Draper::Decorator
  delegate_all

  def default_class
    "default" if default?
  end

  def to_s_a
    [[street, street2], [city, province, country], [postal_code]].map {|i| i.compact.reject{|s| s.blank?}.join(", ")}
  end

  def to_html
    to_s_a.join("<br/>").html_safe
  end

  def to_s
    to_s_a.join("\n")
  end

  def prefill_hash
    model.attributes.slice("street", "street2", "city", "province", "country", "postal_code")
  end

end
