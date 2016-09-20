module Slide

  def valid_moves
    #Create array of possible moves
    poss_moves = generate_poss_moves
    #Is the space in bounds?
    poss_moves = in_bounds(poss_moves)
    #Is the space empty or occupied by opponent piece?
    poss_moves = empty_or_opp(poss_moves)
    #Is the path blocked?
    poss_moves = path_unblocked(poss_moves)
    #Will the space put me into check?
    poss_moves = avoids_check(poss_moves)
  end

  def opp_valid_moves
    #Create array of possible moves
    poss_moves = generate_poss_moves
    #Is the space in bounds?
    poss_moves = in_bounds(poss_moves)
    #Is the space empty or occupied by opponent piece?
    poss_moves = empty_or_opp(poss_moves)
    #Is the path blocked?
    poss_moves = path_unblocked(poss_moves)
  end

  private

  def generate_poss_moves
    poss_moves = @diffs.map do |diff|
      diff_row = diff[0] + @pos[0]
      diff_col = diff[1] + @pos[1]
      [diff_row, diff_col]
    end
  end

  def in_bounds(poss_moves)
    poss_moves.select{ |move| @board.in_bounds?(move)}
  end

  def empty_or_opp(poss_moves)
    poss_moves.select do |move|
      @board[move] == @board.null_piece ||
      @board[move].color != @color
    end
  end

  def avoids_check(poss_moves)
    current_pos = @pos
    poss_moves.reject do |move|
      @board.move(current_pos, move)
      in_check = @board.in_check?(@color)
      @board.move(move, current_pos)
      in_check
    end
  end

  def path_unblocked(poss_moves)
    poss_moves.select do |move|
      row_m, col_m = move
      row_s, col_s = @pos
      diff = [row_m - row_s, col_m - col_s]
      step = diff.map{ |el| el == 0 ? el : el / el.abs}
      new_pos = @pos.dup
      un_blocked = true
      until new_pos == move
        new_pos.map!.with_index { |pos, i| pos + diff[i] }
        un_blocked = false if @board[new_pos].is_a?(Piece)
      end
      un_blocked
    end
  end
end
