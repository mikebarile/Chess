module Slide

  def valid_moves
    #Create array of possible moves
    gen_diffs if self.is_a?(Pawn)
    p poss_moves = generate_poss_moves
    #Is the space in bounds?
    p poss_moves = in_bounds(poss_moves)
    #Is the space empty or occupied by opponent piece?
    p poss_moves = empty_or_opp(poss_moves)
    #Is the path blocked?
    p poss_moves = path_unblocked(poss_moves)
    #Will the space put me into check?
    p poss_moves = avoids_check(poss_moves)
    #If piece is a pawn, ensure it can't move fwd into a piece
    if self.is_a?(Pawn)
      poss_moves = check_fwd(poss_moves)
    end
    poss_moves
  end

  def opp_valid_moves
    #Create array of possible moves
    gen_diffs if self.is_a?(Pawn)
    poss_moves = generate_poss_moves
    #Is the space in bounds?
    poss_moves = in_bounds(poss_moves)
    #Is the space empty or occupied by opponent piece?
    poss_moves = empty_or_opp(poss_moves)
    #Is the path blocked?
    poss_moves = path_unblocked(poss_moves)
    #If piece is a pawn, ensure it can't move fwd into a piece
    if self.is_a?(Pawn)
      poss_moves = check_fwd(poss_moves)
    end
    poss_moves
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
      new_pos[0] += step[0]
      new_pos[1] += step[1]
      un_blocked = true
      until new_pos == move
        new_pos[0] += step[0]
        new_pos[1] += step[1]
        un_blocked = false if @board[new_pos].is_a?(Piece)
      end
      un_blocked
    end
  end

  def check_fwd(poss_moves)
    poss_moves.select do |move|
      if move[1] == 0 && @board[move].is_a?(Piece)
        false
      else
        true
      end
    end
  end
end
