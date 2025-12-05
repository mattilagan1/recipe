class User < ApplicationRecord
  has_secure_password
  has_many :recipes, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
