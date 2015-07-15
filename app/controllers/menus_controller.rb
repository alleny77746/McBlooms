class MenusController < ApplicationController
  respond_to :html, :json
  before_action :menu, only: [:show, :edit, :update, :destroy]
  def index
    authorize! :index, Menu
    @menus = Menu.all
    @grouped_menus = @menus.group_by {|item| item.type }
    respond_with @menus
  end

  def new
    @menu = Menu.new
    authorize! :new, @menu
  end

  def create
    @menu = Menu.new(menu_params)
    authorize! :create, @menu
    flash[:notice] = "#{@menu.title} saved successfully" if @menu.save
    respond_with @menu, location: menus_path
  end

  def edit
    authorize! :edit, menu
  end

  def update
    authorize! :update, menu

    flash[:notice] = "#{menu.title} updated" if @menu.update_attributes(menu_params)
    respond_with @menu, location: menus_path
  end

  def destroy
    authorize! :destroy, menu
    flash[:notice] = "#{menu.title} removed" if @menu.destroy()
    respond_with @menu, location: menus_path
  end

  #######
  private
  #######
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_params
    params.require(:menu).permit(:title, :url, :page_id, :position, :type)
  end
  
  def menu
    @menu ||= Menu.find(params[:id])
  end
end
