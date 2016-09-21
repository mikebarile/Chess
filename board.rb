require 'colorize'
require_relative 'cursor'
require_relative 'display'
require_relative 'piece'
require_relative 'nullpiece'

class Board
  attr_reader :display, :rows, :null_piece

  def initialize
    @rows = Array.new(8){Array.new(8)}
    @null_piece = NullPiece.new
    @display = Display.new(self)
    place_pieces
  end

  def place_pieces()
    nobles = [
      Proc.new{|color, board, pos| Rook.new(color, board, pos)},
      Proc.new{|color, board, pos| Knight.new(color, board, pos)},
      Proc.new{|color, board, pos| Bishop.new(color, board, pos)},
      Proc.new{|color, board, pos| Queen.new(color, board, pos)},
      Proc.new{|color, board, pos| King.new(color, board, pos)},
      Proc.new{|color, board, pos| Bishop.new(color, board, pos)},
      Proc.new{|color, board, pos| Knight.new(color, board, pos)},
      Proc.new{|color, board, pos| Rook.new(color, board, pos)},
    ]
    @rows[0].map!.with_index{ |tile, idx| nobles[idx].call(:white, self, [0, idx])}
    @rows[1].map!.with_index{ |tile, idx| Pawn.new(:white, self, [1, idx])}
    nobles[3], nobles[4] = nobles[4], nobles[3]
    @rows[2..5].each { |row| row.map! { @null_piece } }
    @rows[6].map!.with_index{ |tile, idx| Pawn.new(:black, self, [6, idx])}
    @rows[7].map!.with_index{ |tile, idx| nobles[idx].call(:black, self, [7, idx])}
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @rows[row][col] = val
  end

  def render
    @display.render
  end

  def move(start, end_pos)
    self[end_pos] = self[start]
    self[start] = @null_piece
    self[end_pos].update_pos(end_pos)
  end

  def valid_move(start, end_pos, color)
    if self[start].to_s == " "
      p "Starting position is empty! Try again."
      raise "a"
    end
    unless(in_bounds?(end_pos) && in_bounds?(start))
      p "That position was out of bounds! Try again."
      raise "a"
    end
    unless self[start].valid_moves.include?(end_pos)
      p "Invalid move. Try again!"
      raise "a"
    end
    unless  self[start].color == color
      p "Can't move your opponent's pieces! Try again."
      raise "a"
    end

    self[end_pos] = self[start]
    self[start] = @null_piece
    self[end_pos].update_pos(end_pos)
  end

  def in_bounds?(end_pos)
    x, y = end_pos
    return false if x > 7 || y > 7 || x < 0 || y < 0
    true
  end

  def in_check?(color)
    king_pos = find_king(color)
    check = false

    @rows.each do |row|
      row.each do |square|
        if square != @null_piece && square.color != color &&
            square.opp_valid_moves.include?(king_pos)
          check = true
        end
      end
    end

    check
  end

  def checkmate?(color)
    checkmate = false
    if in_check?(color)
      king_pos = find_king(color)
      checkmate = true
      self[king_pos].valid_moves.each do |poss_move|
        move(king_pos, poss_move)
        checkmate = false unless in_check?(color)
        move[poss_move, king_pos]
      end
    end
    checkmate
  end

  private

  def find_king(color)
    @rows.each_with_index do |row, row_i|
      row.each_with_index do |square, square_i|
        return [row_i, square_i] if (square.is_a?(Piece) &&
            square.symbol == :K && square.color == color)
      end
    end
  end
end
#
# b = Board.new
# b.move([0,3], [5,3])
# b.render
# b[[5,3]].valid_moves.sort
