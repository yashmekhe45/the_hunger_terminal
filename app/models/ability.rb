class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role == "employee"
      can :manage, Order
      cannot :manage,Company
      cannot [:edit, :delete], Order, status: ['placed','confirmed','cancelled']
      cannot [:show,:update,:delete], Company 
    end

    if user.role == "company_admin"
      can :manage, Order
      cannot [:edit, :delete], Order, status: ['placed','confirmed','cancelled']
      can :manage, Terminal
      can :manage, User
      can :manage, MenuItem
      can :index, :order_management
      can :order_detail, :order_management
      can :forward_orders, :order_management
      can :place_orders, :order_management
      can :confirm_orders, :order_management
      can [:read, :update, :get_order_details], Company
      cannot [:index, :delete], Company
      # can :manage, Report
    end

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
