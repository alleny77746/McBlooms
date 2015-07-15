class MyProfileController < ApplicationController
  respond_to :html, :json
  def show
    authorize! :show, user
    respond_with user
  end

  def edit
    authorize! :edit, user
    respond_with user
  end

  def update
    authorize! :update, user
    flash[:notice] = "#{user.name} was updated successfully" if user.update_attributes(profile_params)
    respond_with user, location: my_profile_url
  end

  #######
  private
  #######
  
  def user
    return nil unless current_user
    @user ||= current_user.decorate
    @user
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
