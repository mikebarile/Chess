class Board

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
    @rows[1].map!.with_index{ |tile, idx| Pawn.new(:white, self, [1, idx])
    nobles[3], nobles[4] = nobles[4], nobles[3]
    @rows[2..5].each { |row| row.map! { @null_piece } }
    @rows[6].map!.with_index{ |tile, idx| Pawn.new(:black, self, [6, idx])
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

  def move(start, end_pos)
    raise "Starting position is empty! Try again." if self[start].to_s == " "
    # we fukked up
    raise "That position was out of bounds! Try again." unless (in_bounds?(end_pos) && in_bounds?(start))
    #out of bounds

    @rows[end_pos] = @rows[start]
    @rows[start] = @null_piece
  end

  def in_bounds?(end_pos)
    x, y = pos
    return false if x > 7 || y > 7 || x < 0 || y < 0
    true
  end


end
