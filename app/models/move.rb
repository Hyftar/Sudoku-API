class Move < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :cell

  validates :content, inclusion: { in: 1..9 }, allow_nil: true

  def as_json
    {
      position: cell.position,
      content: content,
      frozen: false
    }
  end

end
