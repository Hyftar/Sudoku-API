class Board < ApplicationRecord
  has_many :cells
  has_many :moves
  accepts_nested_attributes_for :cells

  self.per_page = 10

  def self.create_from_string(board_string)
    position = -1
    b = Board.new
    b.save(validate: false)
    cells =
      board_string
      .split(',')
      .map(&:chomp)
      .map(&:to_i)
      .map do |digit|
        position += 1
        { board: b.id, content: digit.zero? ? nil : digit, position: position }
      end

    values = cells.flatten.map { |e| "(#{e.map { |_k, v| v.nil? ? 'null' : !!v == v ? v ? 1 : 0 : v }.join(',')})" }.join(',')
    ActiveRecord::Base.connection.execute("INSERT INTO cells (\"board_id\", \"content\", \"position\") VALUES #{values}")
  end

  # Get a random board that the specified user has not completed nor started
  # or a completed one if the user has completed all the available boards.
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
    ").first ||
      Board.find_by_sql('
        SELECT *
        FROM boards
        ORDER BY RANDOM()
        LIMIT 1
      ').first
  end

  def get_scores
    Game.where(board: self)
        .map { |x| { user: x.user.name, time_spent: x.finished_at - x.created_at } }
        .sort_by { |x| x[:time_spent] }
        .uniq { |x| x[:user] }
  end

  def as_json(_options = {})
    {
      id: id,
      cells: cells,
      string_representation: to_s
    }
  end

  def as_json_short
    {
      id: id,
      string_representation: to_s_short
    }
  end

  def to_s_short
    cells
      .map(&:as_json)
      .map { |x| x[:content] || 0 }
      .join
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
