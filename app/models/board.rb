class Board < ApplicationRecord
  has_many :cells
  has_many :moves
  accepts_nested_attributes_for :cells

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
