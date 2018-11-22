class Move < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :cell

  validates :content, inclusion: { in: 1..9 }, allow_nil: true

  # Get the most recent moves at specific cells
  def self.get_most_recent_moves_at(cells, game)
    Move.where(cell: cells, game: game).group(:id, :cell_id).order(created_at: :desc)
  end

  def frozen?
    false
  end

  def as_json
    {
      position: cell.position,
      content: content,
      frozen: frozen?
    }
  end
end
