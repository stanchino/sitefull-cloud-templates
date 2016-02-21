class Ability
  include CanCan::Ability

  def initialize(user = nil)
    alias_action :all, :options, :google_auth, to: :read

    user ||= User.new
    can :manage, :all if user.admin?
    return if user.admin?

    can :manage, user
    return unless user.confirmed?

    can [:update, :destroy], Template, user_id: user.id
    can [:read, :create], Template

    can [:destroy], Deployment, template: { user_id: user.id }
    can [:read, :create, :update], Deployment
  end
end
