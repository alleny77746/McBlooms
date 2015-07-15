class UsersController < ApplicationController
  respond_to :html, :json
  def index
    authorize! :manage, User
    @users = User.all
    respond_with @users
  end

  def show
    authorize! :manage, user
    respond_with user
  end

  def new
    @user = User.new
    authorize! :create, @user
    respond_with @user
  end

  def create
    @user = User.new(user_params)
    authorize! :create, @user
    flash[:notice] = "#{@user.name} saved successfully" if @user.save
    respond_with @user
  end

  def edit
    authorize! :edit, user
    respond_with user
  end
  def update
    authorize! :update, user
    flash[:notice] = "#{user.name} was updated successfully" if user.update_attributes(user_params)
    respond_with user
  end

  def destroy
    authorize! :destroy, user
    flash[:notice] = "#{user.name} was updated removed" if user.destroy
    respond_with user
  end

  #######
  private
  #######

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :permission, :mailing_list)
  end

  def user
    @user ||= User.find(params[:id]).decorate
  end
end
