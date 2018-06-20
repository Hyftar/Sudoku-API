class Move < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :cell

  validates :content, inclusion: { in: 1..9 }, allow_nil: true

end