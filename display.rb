require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    puts "  #{(0...@grid.length).to_a.join(" ").colorize(:white)}"
    @grid.each_with_index do |row, i|
      puts "#{i.to_s.colorize(:white)} #{row.map(&:to_s).join(" ")}"
    end
  end
end
