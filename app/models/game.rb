class Game < ApplicationRecord
  belongs_to :board
  belongs_to :user
  has_many :moves

  def as_json
    {
      id: id,
      user: user.name,
      start_time: created_at,
      time_spent: finished_at ? finished_at - created_at : nil,
      finished: self.finished?,
      cells: combined_board,
      string_representation: self.to_s
    }
  end

  # String representation of the game state
  def to_s
    combined_board
      .map { |x| x[:content] || 0 }
      .each_slice(27)
      .map { |x| x.each_slice(9).map { |y| y.each_slice(3).map { |z| z.join(' ') }.join(' | ') }.join("\n") }
      .join("\n------+-------+------\n")
  end

  def finished?
    !finished_at.nil?
  end

  private

  def combined_board
    positions = []
    board.cells.each { |cell| positions << cell.position if cell.content.nil? }
    empty_cells = Cell.where(board: board, position: positions)
    moves = Move.where(cell: empty_cells, game: self)
    player_controlled_cells = empty_cells.map { |cell| moves.find { |move| move.cell == cell } || cell }
    return (board.cells | player_controlled_cells).map(&:as_json)
  end

  # Return { valid? => boolean, offences => [positions] }
  def check_board
    # Combinations needed to be checked for a winning board
    combinations = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8],
      [0, 1, 2, 9, 10, 11, 18, 19, 20],
      [3, 4, 5, 12, 13, 14, 21, 22, 23],
      [6, 7, 8, 15, 16, 17, 24, 25, 26],
      [0, 9, 18, 27, 36, 45, 54, 63, 72],
      [1, 10, 19, 28, 37, 46, 55, 64, 73],
      [2, 11, 20, 29, 38, 47, 56, 65, 74],
      [3, 12, 21, 30, 39, 48, 57, 66, 75],
      [4, 13, 22, 31, 40, 49, 58, 67, 76],
      [5, 14, 23, 32, 41, 50, 59, 68, 77],
      [6, 15, 24, 33, 42, 51, 60, 69, 78],
      [7, 16, 25, 34, 43, 52, 61, 70, 79],
      [8, 17, 26, 35, 44, 53, 62, 71, 80],
      [9, 10, 11, 12, 13, 14, 15, 16, 17],
      [18, 19, 20, 21, 22, 23, 24, 25, 26],
      [27, 28, 29, 30, 31, 32, 33, 34, 35],
      [36, 37, 38, 39, 40, 41, 42, 43, 44],
      [45, 46, 47, 48, 49, 50, 51, 52, 53],
      [54, 55, 56, 57, 58, 59, 60, 61, 62],
      [63, 64, 65, 66, 67, 68, 69, 70, 71],
      [72, 73, 74, 75, 76, 77, 78, 79, 80],
      [27, 28, 29, 36, 37, 38, 45, 46, 47],
      [54, 55, 56, 63, 64, 65, 72, 73, 74],
      [30, 31, 32, 39, 40, 41, 48, 49, 50],
      [57, 58, 59, 66, 67, 68, 75, 76, 77],
      [33, 34, 35, 42, 43, 44, 51, 52, 53],
      [60, 61, 62, 69, 70, 71, 78, 79, 80]
    ]

    board_cells = Cell.find_by(board: self)
    combinations.reject { |combination| combination.map { |position| board_cells.find { |x| x.position == position } }.compact.uniq.count == 9 }
  end
end
