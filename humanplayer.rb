class HumanPlayer
  def initialize(name, board, color)
    @name = name
    @board = board
    @color = color
  end

  def play_turn
    prompt
    begin
      piece_to_move = @board.get_cursor_pos
      pos_to_move = @board.get_cursor_pos
      @board.valid_move(piece_to_move, pos_to_move)
    rescue
      "WRONG! Please try again!"
      retry
    end
  end

  def prompt
    puts "It is your turn, #{name}. Please move a piece."
  end
end
