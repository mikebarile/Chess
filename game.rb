require_relative 'board'
require_relative 'humanplayer'

class Game
    def initialize
      @board = Board.new
      get_players
      @current_player = @player1
    end

    def get_players
      p "Welcome to Chess Masters 2.0!"
      p "White player! Enter your name."
      name = gets.chomp
      @player1 = HumanPlayer.new(name, @board, :white)

      p "Black player! Enter your name."
      name = gets.chomp
      @player2 = HumanPlayer.new(name, @board, :black)
    end

    def play_game
      until @board.checkmate?(:black) || @board.checkmate?(:white)
        @current_player.play_turn
        @current_player = @current_player == @player1 ? @player2 : @player1
      end
    end

    def end_game
      if @board.checkmate?(:white)
        winner = @player1.name
      else
        winner = @player2.name
      end

      p "#{winner}, you have won the game!!!!!!! :D :D :D :D"
    end
end

if __FILE__ == $PROGRAM_NAME
  new_game = Game.new
  new_game.play_game
end
