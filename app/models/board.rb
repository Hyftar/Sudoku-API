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

  def as_json(_options = {})
    {
      id: id,
      cells: cells,
      string_representation: to_s
    }
  end

  def to_s
    cells
      .map(&:as_json)
      .map { |x| x[:content] || 0 }
      .each_slice(27)
      .map { |x| x.each_slice(9).map { |y| y.each_slice(3).map { |z| z.join(' ') }.join(' | ') }.join("\n") }
      .join("\n------+-------+------\n")
  end
end
