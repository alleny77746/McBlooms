module AnlekNestedHelper
  module NestedHelper
    def nested_objects(f, target, options={})
      options.symbolize_keys!
      object_name = options.delete(:object_name) || target.to_s.singularize
      template_name = options.delete(:template_name) || "#{object_name}_template"
      options[:label] = options.fetch(:label) {"Add #{object_name}"}
      options[:icon] ||= "plus"
      options[:type] ||= "primary"
      options[:size] ||= "sm"

      content_tag(:div, class: "nested_set") do
        ''.tap do |html|
          html << javascript_tag("var #{template_name}='#{generate_nested_template(f, target, partial: "#{object_name}_fields")}'")
          html << content_tag(:ol, id: "#{target}_list", data: {template: template_name}) do
            [].tap do |li|
              f.simple_fields_for target do |fields|
                li << render(partial: "#{object_name}_fields", object: fields.object, locals: {f: fields})
              end
            end.join(" ").html_safe
          end
          html << link_to_btn(options.delete(:label), "##{object_name}", options.merge(class: "add_nested_item", rel: "#{target}_list"))
        end.html_safe
      end
    end

    def remove_nested_item(form, options={})
      options.reverse_merge!({class: 'remove_nested_item', alt: 'Remove', type: "default"})
      html = link_to_btn "&times;", '#', options
      unless (form.object.new_record?)
        html += form.hidden_field(:_destroy, class: '_delete')
      end
      html
    end

    def generate_nested_template(form_builder, method, options = {})
      escape_javascript generate_html(form_builder, method, options)
    end

    #######
    private
    #######

    def generate_html(form_builder, method, options = {})
      options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
      options[:partial] ||= method.to_s.singularize
      options[:locals] ||= {}
      options[:form_builder_local] ||= :f

      form_builder.fields_for(method, options[:object], child_index: 'NEW_RECORD') do |f|
        options[:locals].merge!(options[:form_builder_local] => f)
        render(partial: options[:partial], locals: options[:locals], object: f.object)
      end
    end
  end
end
