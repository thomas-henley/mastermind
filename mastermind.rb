require 'pry-byebug'
require 'colorize'

class Mastermind
  attr_accessor :secret, :history, :turn

  COLORS = [:red, :yellow, :green, :cyan, :blue, :magenta]

  def initialize
    self.secret = generate_code
    self.history = []
    self.turn = 0
  end

  def generate_code
    code = []
    4.times do |i|
      code.push(COLORS.sample)
    end
    code
  end

  def display_code(code)
    code.each { |color| print (color.to_s + ' ' * 8)[0..8].send(color.intern) }
    puts ""
  end

  def play
    puts "Secret code:"
    display_code(secret)
    puts "Color choices:"
    display_code(COLORS)
    puts "=" * 64
    puts ""

    until is_won? || is_lost?
      take_turn
      self.turn += 1
    end
  end

  def take_turn
    print "Choose colors, separated by spaces: "
    guess = gets.chomp.split.map { |color| color.intern }
    until guess.length == 4 && guess.all? { |color| COLORS.include? color }
      print "Invalid input, try again: "
      guess = gets.chomp.split.map { |color| color.intern }
    end
    history.push guess
    display_code(history.last)
  end

  def is_won?

  end

  def is_lost?
    self.turn == 10
  end

end

game = Mastermind.new
game.play