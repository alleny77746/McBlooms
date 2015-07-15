class SessionsController < ApplicationController
  def new
    
  end
  def create
    if login(params[:email], params[:password], params[:remember_me])
      flash[:notice] = "You're now signed in"
      redirect_back_or_to root_url
    else
      flash[:error] = "Invalid Email or Password, please try again"
      render :new
    end
  end
  def destroy
    logout()
    flash[:notice] = "You're now signed out"
    redirect_to root_url
  end
end
