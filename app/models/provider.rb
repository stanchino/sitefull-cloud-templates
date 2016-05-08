class Provider < ActiveRecord::Base
  belongs_to :organization

  has_many :accesses, dependent: :destroy
  has_many :accounts, through: :accesses
  has_many :settings, class_name: 'ProviderSetting', inverse_of: :provider, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :textkey, presence: true, uniqueness: { scope: :organization_id }, inclusion: { in: Sitefull::Cloud::Provider::PROVIDERS }

  accepts_nested_attributes_for :settings
end
