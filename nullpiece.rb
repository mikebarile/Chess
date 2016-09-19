class NullPiece
  # include Singleton
  attr_reader :to_s
  def initialize
    @to_s = "_".colorize(:black)
  end
end
