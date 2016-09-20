class Piece
  attr_reader :symbol, :color

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @diffs = []
  end

  def to_s
    @string.colorize(@color)
  end

  def valid_moves
    #Create array of possible moves
    poss_moves = generate_poss_moves
    #Is the space in bounds?
    poss_moves = in_bounds(poss_moves)
    #Is the space empty or occupied by opponent piece?
    poss_moves = empty_or_opp(poss_moves)
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
end

class King < Piece
  def initialize(color, board, pos)
    @symbol = :K
    @string = "♔"
    super
    gen_diffs
  end

  def gen_diffs
    @diffs = [
      [1, -1],
      [1, 0],
      [1, 1],
      [0, -1],
      [0, 1],
      [-1, -1],
      [-1, 0],
      [-1, 1]
    ]
  end
end

class Queen < Piece
  def initialize(color, board, pos)
    @symbol = :Q
    @string = "♕"
    super
    gen_diffs
  end

  def gen_diffs
    @diffs = []
    (-7..7).each { |i| (-7..7).each { |j| @diffs << [i, j] } }
    @diffs.delete([0, 0])
    @diffs.select!{ |arr| arr[0] == 0 || arr[1] == 0 ||
        arr[0].abs == arr[1].abs }
  end
end

class Rook < Piece
  def initialize(color, board, pos)
    @symbol = :R
    @string = "♖"
    super
    gen_diffs
  end

  def gen_diffs
    @diffs = []
    (-7..7).each do |x|
      @diffs << [0, x]
      @diffs << [x, 0]
    end
    @diffs.delete([0, 0])
  end
end

class Bishop < Piece
  def initialize(color, board, pos)
    @symbol = :B
    @string = "♗"
    super
    gen_diffs
  end

  def gen_diffs
    @diffs = []
    (-7..7).each do |i|
      (-7..7).each do |j|
        @diffs << [i, j]
      end
    end

    @diffs.select! { |arr| arr[0] == arr[1].abs }
  end
end

class Knight < Piece
  def initialize(color, board, pos)
    @symbol = :Kn
    @string = "♘"
    super
    gen_diffs
  end

  def gen_diffs
    @diffs = [
      [2,-1],
      [2,1],
      [1,-2],
      [1,2],
      [-1,-2],
      [-1,2],
      [-2,-1],
      [-2,1]
    ]
  end
end

class Pawn < Piece

  def initialize(color, board, pos)
    @symbol = :P
    @string = "♙"
    @first_move = true
    super
    gen_moves
  end

  #placeholder
  def gen_moves
    @diffs = [1, 1]
  end

  #placeholder
  def valid_moves
    [1, 1]
  end
end
