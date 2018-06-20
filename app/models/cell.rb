class Cell < ApplicationRecord
  belongs_to :board
  has_many :moves
  validates :position, presence: true, inclusion: { in: 0..80 }
  validates :content, inclusion: { in: 1..9 }, allow_nil: true
end
