class Provider < ActiveRecord::Base
  has_many :accesses, dependent: :destroy
  has_many :settings, class_name: 'ProviderSetting', inverse_of: :provider, dependent: :destroy
  has_many :users, through: :accesses

  validates :name, presence: true, uniqueness: true
  validates :textkey, presence: true, uniqueness: true
end
