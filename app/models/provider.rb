class Provider < ActiveRecord::Base
  belongs_to :organization

  has_many :deployments, dependent: :destroy
  has_many :credentials, dependent: :destroy
  has_many :accounts, through: :credentials
  has_many :settings, class_name: 'ProviderSetting', inverse_of: :provider, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :textkey, presence: true, uniqueness: { scope: :organization_id }, inclusion: { in: Sitefull::Cloud::Provider::PROVIDERS }

  accepts_nested_attributes_for :settings
end
