class TemplateArgument < ActiveRecord::Base
  belongs_to :template

  validates :textkey, presence: true, uniqueness: { scope: :template_id }
  validates :name, presence: true, uniqueness: { scope: :template_id }

  default_scope { order(:created_at) }
end
