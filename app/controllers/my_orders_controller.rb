class MyOrdersController < ApplicationController
  before_action :require_login
  before_action :order, only: [:show]
  def index
    authorize! :index, Order
    @orders = current_user.orders.all.decorate
  end

  def show
    authorize! :show, order
  end

  #######
  private
  #######
  
  def order
    @order ||= current_user.orders.find(params[:id]).decorate
  end
end
