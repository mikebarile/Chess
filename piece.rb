require_relative 'slide'
require_relative 'hop'

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
end

class King < Piece
  include Hop

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
  include Slide

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
  include Slide

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
  include Slide

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
  include Hop

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

  def opp_valid_moves
    [1, 1]
  end
end
