class AddressesController < ApplicationController
  respond_to :html, :json
  def index
    authorize! :read, Address
    @addresses = user.addresses.all.decorate
    respond_with @addresses
  end

  def new
    @address = user.addresses.new
    authorize! :create, @address
    respond_with @address
  end

  def create
    @address = user.addresses.new(address_params)
    authorize! :create, @address
    flash[:notice] = "#{address.name} saved successfully" if @address.save && @address.addressable.save
    respond_with @address, location: my_profile_addresses_path
  end

  def edit
    authorize! :edit, address.object
    respond_with address
  end

  def update
    authorize! :update, address.object
    flash[:notice] = "#{address.name} was updated successfully" if address.update_attributes(address_params)
    respond_with address, location: my_profile_addresses_path
  end

  def destroy
    authorize! :destroy, address.object
    flash[:notice] = "#{address.name} was removed successfully" if address.destroy
    respond_with address, location: my_profile_addresses_path
  end

  def mark_default
    authorize! :update, address.object
    address.update_attribute(:default, true)
    respond_with address, location: my_profile_addresses_path
  end

  #######
  private
  #######

  def user
    current_user
  end

  def address
    @address ||= user.addresses.find(params[:id]).decorate
  end

  def address_params
    params.require(:address).permit(:id, :name, :street, :street2, :city, :province, :country, :postal_code, :default)
  end
end
