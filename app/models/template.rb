class Template < ActiveRecord::Base
  OPERATING_SYSTEMS = [
    %w(debian Debian),
    %w(centos CentOS),
    ['rhel', 'Red Hat Enterprice Linux'],
    %w(suse SUSE),
    %w(ubuntu Ubuntu),
    ['windows_server_2008', 'Windows Server 2008'],
    ['windows_server_2012', 'Windows Server 2012'],
    ['windows_server_2016', 'Windows Server 2016']
  ].freeze

  acts_as_taggable
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :os, presence: true
  validates :script, presence: true

  belongs_to :user
  has_many :deployments
end
