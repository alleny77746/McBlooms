class Ability
  include CanCan::Ability

  def initialize(user)

    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :access, :ckeditor
      can :manage, :all
      cannot :register, User #prevents admin from registering a new user via register link (not creating though)
    else
      if user.new_record?
        can :register, User
      end
      can :read, Category
      can :read, Product
      can :read, Ingredient, key: true
      can :show, Price, target: Price::DISTRIBUTOR if user.distributor?
      can :show, Price, target: Price::CONSUMER if user.consumer?
      can :manage, Cart
      can :read, Order, user_id: user.id
      can [:show, :update], User, id: user.id
      can [:read], Page
      can :manage, Address do |address|
        address.addressable.id == user.id
      end
    end
  end
end
