class Template < ActiveRecord::Base
  OPERATING_SYSTEMS = [
    %w(debian Debian),
    %w(freebsd FreeBSD),
    %w(centos CentOS),
    ['rhel', 'Red Hat Enterprice Linux'],
    %w(suse SUSE),
    %w(ubuntu Ubuntu),
    ['windows_2003', 'Windows 2003'],
    ['windows_2008', 'Windows 2008'],
    ['windows_2012', 'Windows 2012'],
    %w(other Other)
  ].freeze

  acts_as_taggable
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :os, presence: true
  validates :script, presence: true

  belongs_to :user
  has_many :deployments
end
