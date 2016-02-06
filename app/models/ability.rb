class Ability
  include CanCan::Ability

  def initialize(user = nil)
    alias_action :all, to: :read

    user ||= User.new
    can :manage, user
    return unless user.confirmed?

    can [:update, :destroy], Template, user_id: user.id
    can [:read, :create], Template

    can [:destroy], Deployment, template: { user_id: user.id }
    can [:read, :create], Deployment
  end
end
