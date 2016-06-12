class Template < ActiveRecord::Base
  OPERATING_SYSTEMS = [
    %w(debian Debian),
    %w(centos CentOS),
    ['rhel', 'Red Hat Enterprice Linux'],
    %w(suse SUSE),
    %w(ubuntu Ubuntu)
  ].freeze

  acts_as_taggable

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :os, presence: true
  validates :script, presence: true

  belongs_to :user
  has_many :deployments
  has_many :arguments, class_name: 'TemplateArgument', dependent: :destroy, inverse_of: :template

  accepts_nested_attributes_for :arguments
end
