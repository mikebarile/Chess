class HumanPlayer
  def initialize(name, board, color)
    @name = name.capitalize
    @board = board
    @color = color
  end

  def play_turn
    select_piece = Proc.new{p "Select a piece you would like to move and press enter."}
    select_move = Proc.new{p "Now select the piece's destination and press enter."}
    begin
      piece_to_move = @board.display.get_cursor_pos(@name, &select_piece)
      pos_to_move = @board.display.get_cursor_pos(@name, &select_move)
      @board.valid_move(piece_to_move, pos_to_move, @color)
    rescue
      sleep(2)
      retry
    end
  end
end
