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
    date = Time.now
    filename = "saved_game_#{date.strftime("%c")}"
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    File.open("saved_games/#{filename}", 'w') {|file| file.write    Marshal.dump(self)}
    abort 'Game Saved.'
  end

  def validate_file
    valid = false

    saved_games = Dir.children("saved_games")
    puts "Which file do you want to load? (Enter number)"

    saved_games.each_with_index do |file, index|
      unless file == ".DS_Store"
        puts "[#{index}] #{file}"
      end
    end

    until valid
      file_number = gets.chomp.to_i

      if file_number > saved_games.length + 1 || saved_games[file_number] == ".DS_Store"
        puts "Please input a valid file number:"
        file_number = gets.chomp.to_i
      else
        valid = true
      end
    end

    saved_games[file_number]
  end

  def load_game
    filename = validate_file

    game = Marshal.load(File.open("saved_games/#{filename}", "r") {|file| file.read})

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

    until answer == 'y' || answer == 'n'
      answer = gets.chomp.downcase
    end

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
          puts "Gameover. You've been hanged. The secret word was #{@secret_word}."
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
