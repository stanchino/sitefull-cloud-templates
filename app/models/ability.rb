class Ability
  include CanCan::Ability

  def initialize(user = nil)
    alias_action :all, :options, :validate, to: :read

    user ||= User.new
    can :manage, :all if user.admin?
    return if user.admin?

    can :manage, user
    return unless user.confirmed?

    setup_user_permissions(user)
  end

  def setup_user_permissions(user)
    can :oauth, Provider

    can :create, Credential
    can [:read, :update, :destroy], Credential, account: { accounts_user: { user_id: :user_id } }

    can [:read, :create], Template
    can [:update, :destroy], Template, user_id: user.id

    can :create, Deployment
    can [:read, :update, :destroy], Deployment, template: { user_id: user.id }
  end
end
