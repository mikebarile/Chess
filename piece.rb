class Piece
  attr_reader :symbol, :color

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
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
    avoids_check(poss_moves)
  end

  private
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
      in_check = @board.in_check?
      @board.move(move, current_pos)
      in_check
    end
  end

  def generate_poss_moves
    poss_moves = DIFFS.map do |diff|
      diff_row = diff[0] + @pos[0]
      diff_col = diff[1] + @pos[1]
      [diff_row, diff_col]
    end
  end

end

class King < Piece
  DIFFS = [
    [1, -1],
    [1, 0],
    [1, 1],
    [0, -1],
    [0, 1],
    [-1, -1],
    [-1, 0],
    [-1, 1]
  ]

  def initialize(color, board, pos)
    @symbol = :K
    @string = "♔"
    super
  end
end

class Queen < Piece
  DIFFS = []
  (-7..7).each { |i| (-7..7).each { |j| DIFFS << [i, j] } }
  DIFFS.delete([0, 0])
  DIFFS.select!{ |arr| arr[0] == 0 || arr[1] == 0 ||
      arr[0].abs == arr[1].abs }

  def initialize(color, board, pos)
    @symbol = :Q
    @string = "♕"
    super
  end
end

class Rook < Piece
  DIFFS = []
  (-7..7).each do |x|
    DIFFS << [0, x]
    DIFFS << [x, 0]
  end
  DIFFS.delete([0, 0])

  def initialize(color, board, pos)
    @symbol = :R
    @string = "♖"
    super
  end
end

class Bishop < Piece
  DIFFS = []
  (-7..7).each do |i|
    (-7..7).each do |j|
      DIFFS << [i, j]
    end
  end

  DIFFS.select! { |arr| arr[0] == arr[1].abs }

  def initialize(color, board, pos)
    @symbol = :B
    @string = "♗"
    super
  end
end

class Knight < Piece
  DIFFS = [
    [2,-1],
    [2,1],
    [1,-2],
    [1,2],
    [-1,-2],
    [-1,2],
    [-2,-1],
    [-2,1]
  ]

  def initialize(color, board, pos)
    @symbol = :Kn
    @string = "♘"
    super
  end
end

class Pawn < Piece
  DIFFS = [1, 1]
  def initialize(color, board, pos)
    @symbol = :P
    @string = "♙"
    @first_move = true
    super
  end

  def valid_moves
  end
end
