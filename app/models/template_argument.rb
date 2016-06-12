class TemplateArgument < ActiveRecord::Base
  belongs_to :template

  validates :textkey, presence: true, uniqueness: { scope: :template_id }
  validates :name, presence: true, uniqueness: { scope: :template_id }
  validates :validator, presence: true, inclusion: { in: DeploymentArgumentsValidator::VALIDATORS.keys.map(&:to_s) }

  default_scope { order(:created_at) }
end
