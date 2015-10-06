module AnlekBootstrapHelper
  module CrudButtonHelper
    extend ActiveSupport::Concern
    include ButtonHelper
    STYLE= {
      list: {icon: "arrow-left", type: "default"},
      new: {icon: "plus", type: "primary"},
      edit: {icon: "pencil", type: "success"},
      delete: {icon: "times", type: "danger"}
    }

    def list_btn_for models, options={}
      models = Array.wrap(models)
      options = stylize_options(options, :list)
      model = models.last
      label =  extract_label options, "Back to #{model.name.to_s.pluralize}"
      link_to_btn(label, polymorphic_path(models), options) if cancan? :read, models
    end

    def new_btn_for models, options={}
      models = Array.wrap(models)
      options = stylize_options(options, :new)
      model = models.last
      label =  extract_label options, "Add #{model.name}"
      link_to_btn(label,  polymorphic_path(models, action: :new), options) if cancan? :create, models
    end

    def edit_btn_for models, options={}
      models = Array.wrap(models)
      options = stylize_options(options, :edit)
      label =  extract_label options, "Edit"
      link_to_btn(label,polymorphic_path(models, action: :edit), options) if cancan? :edit, models
    end

    def delete_btn_for models, options={}
      models = Array.wrap(models)
      options = append_delete_options(stylize_options(options, :delete))
      label =  extract_label options, "Remove"
      link_to_btn(label, models, options) if cancan? :delete, models
    end

    #######
    private
    #######

    def cancan?(type, models)
      return true unless AnlekBootstrapHelper.using_cancan?
      can? type, models.last
    end

    def append_delete_options(options={})
      data = options.delete(:data) || {}
      data[:method] ||= options.delete(:method) || "DELETE"
      data[:confirm] ||= options.delete(:confirm) || "Are you sure?"
      options[:data] = data
      options
    end

    def stylize_options(options, style)
      options.symbolize_keys!
      options = options.reverse_merge(STYLE[style])
    end

    def extract_label(options, default="")
      ActiveSupport::Deprecation.warn("option(:name) is no longer used, please use option(:label)") if options.key?(:name)
      options.delete(:label) || options.delete(:name) || default
    end

  end
end