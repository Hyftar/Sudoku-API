class BoardsController < ApplicationController
  before_action :set_board, only: %i[show update destroy play]
  before_action :set_random_board, only: %i[random]

  def play
    res = @board.play(play_params)
    if res == :ok
      json_response(@board)
    else
      json_response(res)
    end
  end

  def random
    show
  end

  def show
    json_response(@board)
  end

  def index
    @boards = Board.first(50)
    json_response(@boards)
  end

  def update
    @board.update(board_params)
  end

  def create
    @board = Board.create!(board_params)
    json_response(@board, :created)
  end

  def destroy
    @board.destroy
    head :no_content
  end

  private

  def board_params
    params.require(:board).permit(cells_attributes: %i[position content set])
  end

  def play_params
    params.require(:play).permit(:content, :position)
  end

  def set_random_board
    @board = Board.find_by_sql('SELECT * FROM boards WHERE completed_count = (SELECT MIN(completed_count) FROM boards)').sample
    @cells = @board.cells
  end

  def set_board
    @board = Board.find(params[:id])
    @cells = @board.cells
  end
end
