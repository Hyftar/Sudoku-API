b = File.open('db/sudokus.csv', 'r').readlines.map { |x| x.split(',').map(&:chomp).map(&:to_i) }.map do |x|
  position = -1
  b = Board.new
  b.save(validate: false)
  x.map do |y|
    position += 1
    if y.nonzero?
      { board: b.id, content: y, position: position, set: true }
    else
      { board: b.id, content: nil, position: position, set: false }
    end
  end
end

values = b.flatten.map { |e| "(#{e.map { |_k, v| v.nil? ? 'null' : !!v == v ? v ? 1 : 0 : v }.join(',')})" }.join(',')
ActiveRecord::Base.connection.execute("INSERT INTO cells (\"board_id\", \"content\", \"position\", \"set\") VALUES #{values}")
