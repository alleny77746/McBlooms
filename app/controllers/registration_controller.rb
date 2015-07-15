class RegistrationController < ApplicationController
  respond_to :html
  def new
    @user = User.new
    authorize! :register, @user
    respond_with @user
  end

  def create
    @user = User.new(registration_params)
    authorize! :register, @user
    if @user.save
      auto_login(@user)
      flash[:notice] = "Your registartion was successful."
    end
    respond_with @user, location: root_url
  end


  #######
  private
  #######

  def registration_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :mailing_list)
  end
end
