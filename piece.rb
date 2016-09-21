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

  def update_pos(new_pos)
    @pos = new_pos
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

    @diffs.select! { |arr| arr[0].abs == arr[1].abs }
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

  include Slide

  def initialize(color, board, pos)
    @symbol = :P
    @string = "♙"
    super
    gen_diffs
  end

  #placeholder
  def gen_diffs
    @diffs = []

    @diffs << [1, 0] if @color == :white
    @diffs << [-1, 0] if @color == :black

    @diffs << [2, 0] if @color == :white && @pos[0] == 1
    @diffs << [-2, 0] if @color == :black && @pos[0] == 6

    white_diag_diffs = [[1, 1], [1, -1]]
    black_diag_diffs = [[-1, -1], [-1, 1]]

    if @color == :white
      @diffs.concat(find_diags(white_diag_diffs))
    else
      @diffs.concat(find_diags(black_diag_diffs))
    end
    # if for diagonals
  end

  private
  def find_diags(diff)
    diff.select do |diff|
      d_row, d_col = diff
      row, col = @pos
      new_idx = [(d_row + row), (d_col + col)]
      @board[new_idx].is_a?(Piece) && @board[new_idx].color != @color
    end
  end
end
