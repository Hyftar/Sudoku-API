class BoardsController < ApplicationController
  before_action :set_board, only: %i[show update destroy play]
  before_action :authorize_user, only: %i[update destroy create index]

  def scores
    board = Board.find(params[:board_id])
    json_response(board.get_scores)
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

  def authorize_user
    authorize Board
  rescue Pundit::NotAuthorizedError
    json_response status: :forbidden
  end

  def scores_params
    params.permit(:board_id)
  end

  def board_params
    params.require(:board).permit(cells_attributes: %i[position content set])
  end

  def set_board
    @board = Board.find(params[:id])
    @cells = @board.cells
  end
end
