class GamesController < ApplicationController
  before_action :set_user_current_game, only: %i[destroy create peak play]

  def peak
    json_response(@current_game.as_json || { message: 'You are not part of any game.' })
  end

  def play
    play_params_hash = play_params
    cell = @current_game.board.cells.find_by(position: play_params_hash[:position].to_i)

    return json_response(message: 'You are not part of any game.', status: 400) if @current_game.nil?
    return json_response(message: 'The selected cell cannot be changed.', status: 400) if cell.frozen?
    move_content = play_params_hash[:content].to_i
    return json_response(message: 'Invalid move.', status: 400) unless (1..9).cover?(move_content)

    Move.create!(game: @current_game, user: @current_user, cell: cell, content: move_content)
    status = @current_game.check_board
    if status[:completed]
      @current_game.finished_at = Time.now.utc
      @current_game.save
    end
    json_response(board: @current_game.as_json, offences: status[:offences], completed: status[:completed])
  end

  def create
    create_params_hash = create_params
    if @current_game
      json_response(
        message: 'You still have a game running.',
        game_id: @current_game.id,
        board_id: @current_game.board_id
      )
    else
      @current_game = Game.create!(
        board: Board.find(create_params_hash[:board_id].to_i) || Board.get_random_non_completed_board(@current_user),
        user: @current_user
      )
      json_response(
        message: 'Sucessfully started a game.',
        game_id: @current_game.id,
        board_id: @current_game.board_id
      )
    end
  end

  def destroy
    if @current_game
      @current_game.moves.destroy_all
      @current_game.destroy!
    else
      json_response(message: 'You are not part of any game.')
    end
  end

  private

  def set_user_current_game
    @current_game = @current_user.games.find_by(finished_at: nil)
  end

  def create_params
    params.permit(:board_id)
  end

  def play_params
    params.require(:play).permit(:position, :content)
  end
end
