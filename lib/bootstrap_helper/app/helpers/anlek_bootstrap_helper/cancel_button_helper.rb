module AnlekBootstrapHelper
  module CancelButtonHelper
    extend ActiveSupport::Concern
    include ButtonHelper

    def cancel_btn_for(models, options = {})
      options.symbolize_keys!
      models = Array.wrap(models)
      label = options.delete(:label) || "Cancel"
      url = options.delete(:url) || model_link(models)

      options[:icon] ||= "ban"
      options[:data] ||= {}
      options[:data][:confirm] ||= "Are you sure you want to cancel?"

      link_to_btn label, url, options
    end

    #######
    private
    #######

    def model_link(model)
      active_model = model.last

      return model if active_model.persisted?

      active_model = model.pop
      model << active_model.class
      model
    end
  end
end
