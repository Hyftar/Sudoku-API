class User < ApplicationRecord
  has_secure_password
  has_many :moves
  has_many :games

  validates :name, uniqueness: true

  def completed_boards
    Game.where(user: self).where.not(finished_at: nil)
  end
end
