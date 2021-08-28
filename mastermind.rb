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
    display_colors

    until is_won? || is_lost?
      take_turn
      give_feedback
      self.turn += 1
    end

    display_results
  end

  def display_colors
    puts "<== MASTERMIND ==>"
    # puts "Secret code:"
    # display_code(secret)
    puts "Color choices:"
    display_code(COLORS)
    puts "A '^' means a color is in the right place."
    puts "A '>' means a color is correct, but in the wrong positon."
    puts "Enter colors separated by spaces, like 'green cyan magenta blue'."
    puts "=" * 64
    puts ""
  end

  def take_turn
    print "Turn #{turn + 1}: "
    guess = gets.chomp.split.map { |color| color.intern }
    until guess.length == 4 && guess.all? { |color| COLORS.include? color }
      print "Invalid input, try again: "
      guess = gets.chomp.split.map { |color| color.intern }
    end
    history.push guess
    display_code(history.last)
  end

  def give_feedback
    right_color = 0
    right_position = 0
    color_count = Hash.new(0)
    history.last.each_with_index do |guess_color, index| 
      right_position += 1 if guess_color == secret[index]

      secret_count = secret.count { |color| color == guess_color }
      guess_count = history.last.count { |color| color == guess_color }
      if color_count[guess_color] == 0
        color_count[guess_color] = [guess_count, secret_count].min
        right_color += color_count[guess_color]
      end
    end
    print 'Feedback: '
    print '^' * right_position
    print '>' * (right_color - right_position)
    puts "\n\n"
  end

  def is_won?
    history.last == self.secret
  end

  def is_lost?
    self.turn == 12
  end

  def display_results
    puts '=' * 64
    if is_won?
      puts '+---------+'
      puts "| Winner! |"
      puts '+---------+'
    elsif is_lost?
      puts '+----------+'
      puts "| YOU DIED |"
      puts '+----------+'
    end

    puts "Secret code was:"
    display_code self.secret
  end

end

game = Mastermind.new
game.play