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
    #really complicated
  end

  private

  def move_into_check?
  end
end

class King < Piece
  diffs = [
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
  diffs = []
  (-7..7).each { |i| (-7..7).each { |j| diffs << [i, j] } }
  diffs.delete([0, 0])
  diffs.select!{|arr| arr[0] == 0 || arr[1] == 0 ||
      abs(arr[0]) == abs(arr[0])}

  def initialize(color, board, pos)
    @symbol = :Q
    @string = "♕"
    super
  end
end

class Rook < Piece
  diffs = []
  (-7..7).each do |x|
    diffs << [0, x]
    diffs << [x, 0]
  end
  diffs.delete([0, 0])

  def initialize(color, board, pos)
    @symbol = :R
    @string = "♖"
    super
  end
end

class Bishop < Piece
  diffs = []
  (-7..7).each do |i|
    (-7..7).each do |j|
      diffs << [i, j]
    end
  end

  diffs.select! { |arr| arr[0] == abs(arr[1]) }

  def initialize(color, board, pos)
    @symbol = :B
    @string = "♗"
    super
  end
end

class Knight < Piece
  diffs = [
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
  def initialize(color, board, pos)
    @symbol = :P
    @string = "♙"
    @first_move = true
    super
  end

  def valid_moves
  end
end
