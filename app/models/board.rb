class Board < ApplicationRecord
  has_many :cells
  has_many :moves
  accepts_nested_attributes_for :cells

  # Get a random board that the specified user has not completed nor started
  def self.get_random_non_completed_board(user)
    Board.find_by_sql("
      SELECT *
      FROM boards
      WHERE id NOT IN (
        SELECT board_id
        FROM games
        WHERE user_id = #{user.id}
      )
      ORDER BY RANDOM()
      LIMIT 1
    ").first
  end

  def as_json(options = {})
    h = super(options)
    h[:cells] = cells.map { |x| x.slice(:position, :content) }
    h
  end

  def play(args)
    cell = Cell.find_by(position: args[:position], board: id)
    # if !cell.set
    #   cell.content = args[:content]
    #   cell.save
    #   if check_board
    #     self.completed_count += 1
    #     get_non_frozen_cells.each { |b_cell| b_cell.content = nil }.each(&:save)
    #   end
    #   :ok
    # else
    #   :unauthorized
    # end
  end
end
