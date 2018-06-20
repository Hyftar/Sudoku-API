# Boards and Cells seeds
cells =
  File
  .open('db/sudokus.csv', 'r')
  .readlines
  .map { |x| x.split(',').map(&:chomp).map(&:to_i) }
  .map do |row|
    position = -1
    b = Board.new
    b.save(validate: false)
    row.map do |digit|
      position += 1
      { board: b.id, content: digit.zero? ? nil : digit, position: position }
    end
  end

# Here we use Raw SQL to skip validations for faster inserts
values = cells.flatten.map { |e| "(#{e.map { |_k, v| v.nil? ? 'null' : !!v == v ? v ? 1 : 0 : v }.join(',')})" }.join(',')
ActiveRecord::Base.connection.execute("INSERT INTO cells (\"board_id\", \"content\", \"position\") VALUES #{values}")
