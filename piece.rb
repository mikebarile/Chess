class Piece
  attr_reader :symbol

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def to_s
    @symbol.to_s.colorize(@color)
  end

  def valid_moves
    #really complicated
  end

  private

  def move_into_check?
  end
end

class King

  def initialize(color, board, pos)
    @symbol = :♔
    super
  end
end

class Queen
  def initialize(color, board, pos)
    @symbol = :♕
    super
  end
end

class Rook
  def initialize(color, board, pos)
    @symbol = :♖
    super
  end
end

class Bishop
  def initialize(color, board, pos)
    @symbol = :♗
    super
  end
end

class Knight
  def initialize(color, board, pos)
    @symbol = :♘
    super
  end
end

class Pawn
  def initialize(color, board, pos)
    @symbol = :♙
    super
  end
end
