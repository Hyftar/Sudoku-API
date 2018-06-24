class User < ApplicationRecord
  has_secure_password
  has_many :moves
  has_many :games
end
