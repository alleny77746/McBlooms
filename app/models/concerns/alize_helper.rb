### AlizeHelper
# Used to auto build alize field in a decorator to autoload fields or
# look them up if they're missing.
module AlizeHelper
  extend ActiveSupport::Concern

  included do
    object_class.alize_from_callbacks.each do |callback|
      parent_name = callback.metadata.class_name.underscore
      callback.denorm_attrs.each do |attribute|
        define_method "#{parent_name}_#{attribute}" do
          if send("#{parent_name}_fields").nil?
            send("#{parent_name}_fields=", {})
            save(validate: false)
          end
          send("#{parent_name}_fields").fetch(attribute.to_s) { object.send(parent_name).try(:send, attribute) }
        end
      end
    end
  end
end
