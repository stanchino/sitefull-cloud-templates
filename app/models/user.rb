class User < ActiveRecord::Base
  acts_as_tagger
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :templates
  has_many :accounts_users, dependent: :destroy
  has_many :accounts, through: :accounts_users
  belongs_to :current_account, class_name: 'Account'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true

  delegate :organization, to: :current_account
end
