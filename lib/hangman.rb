# Hangman game class
class Game
  HANGMANPICS = ['''
    +---+
    |   |
    |
    |
    |
    |
  =========''', '''
    +---+
    |   |
    |   O
    |
    |
    |
  =========''', '''
    +---+
    |   |
    |   O
    |   |
    |
    |
  =========''', '''
    +---+
    |   |
    |   O
    |  /|
    |
    |
  =========''', '''
    +---+
    |   |
    |   O
    |  /|\
    |
    |
  =========''', '''
    +---+
    |   |
    |   O
    |  /|\
    |  /
    |
  =========''', '''
    +---+
    |   |
    |   O
    |  /|\
    |  / \
    |
  =========''']

  def get_random_word
    all_words = []
    File.readlines('google-10000-english.txt').each { |word| all_words << word.chomp }
    all_words.select { |word| word.length > 5 && word.length < 12 }.sample
  end

  def welcome_message
    puts "Welcome to Hangman. Can you guess the secret word?"
    puts "Do you want to [1] New Game
               [2] Load Game"
    input = gets.chomp

    if input == '1'
      puts HANGMANPICS[@turn]
      puts "  #{@guess.join(' ')}"
      puts "\n"
      puts "Choose your first letter:"
    elsif input == '2'
      load_game
      # print_gameboard
      # puts "Choose another letter (or type 'save' to save progress):"
      # game_loop
    end
  end

  def game_start
    @gameover = false
    @secret_word = get_random_word
    @turn = 0
    @used_letters = []
    @guess = Array.new(@secret_word.length, '_')

    welcome_message
    game_loop
  end

  def save_game
    # File.open('saved_games/saved_game.yml', 'w') { |file| file.write(self) }
    File.open("saved_games/saved_game.yml", 'w') {|file| file.write    Marshal.dump(self)}
    abort 'Game Saved.'
  end

  def load_game
    game = Marshal.load(File.open("saved_games/saved_game.yml", "r") {|file| file.read})
    game.print_gameboard
    puts "Choose another letter:"
    game.game_loop
  end

  def print_gameboard
    puts HANGMANPICS[@turn]
    puts " #{@guess.join(' ')}"
    puts "\n"
    puts " #{@used_letters.join(' ')}"
    puts "\n"
  end

  def replay
    puts "Do you want to play again? [y/n]"
    answer = gets.chomp.downcase

    exit unless answer == 'y'

    game_start
  end

  def game_loop
    until @gameover
      @letter = gets.chomp.downcase

      if @letter == 'save'
        save_game
      elsif @letter.length > 1
        puts "Please enter a single letter at a time (or type 'save' to save game):"
      elsif @guess.include?(@letter) || @used_letters.include?(@letter)
        puts "You've already guessed that letter. Choose another:"
      elsif !@letter.match?(/[[:alpha:]]/)
        puts "Please choose a letter from A-Z (or type 'save' to save progress)"
      elsif @secret_word.include?(@letter)
        indexes = @secret_word.split('').each_index.select { |i| @secret_word[i] == @letter }
        indexes.each { |index| @guess[index] = @letter }
        @used_letters.push(@letter)
        print_gameboard

        if @guess.include?('_')
          puts "Choose another letter (or type 'save' to save progress):"
        else
          @gameover = true
          puts "You've guessed the secret word!"
          replay
        end
      else
        @turn += 1

        if @turn == 6
          @gameover = true
          print_gameboard
          puts "Gameover. You've been hanged. The secret word was #{@secret_word}"
          replay
        else
          @used_letters.push(@letter)
          print_gameboard
          puts "Choose another letter (or type 'save' to save progress):"
        end
      end
    end
  end
end

hangman = Game.new
hangman.game_start
