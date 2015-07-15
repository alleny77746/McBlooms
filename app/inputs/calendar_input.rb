class CalendarInput  < SimpleForm::Inputs::StringInput
  def input_type
    :string
  end

  def input
    input_html_options[:data] ||= {}
    input_html_options[:data][:behaviour]= 'datepicker'
    input_html_options[:class] << " form-control"

    out = template.content_tag :div, class: "input-group" do
      inner = @builder.text_field(attribute_name, input_html_options)
      inner += template.content_tag :span, class: "input-group-addon" do
        template.content_tag(:i, "", class: "fa fa-calendar")
      end
    end

    out.html_safe
  end

end