class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :templates
end
