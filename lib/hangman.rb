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
    puts HANGMANPICS[@turn]
    puts "  #{@guess.join(' ')}"
    puts "\n"
    puts "Choose your first letter:"
  end

  def game_start
    @gameover = false
    @secret_word = get_random_word
    @turn = 0
    @used_letter = []
    @guess = Array.new(@secret_word.length, '_')

    welcome_message
    game_loop
  end

  def print_gameboard
    puts HANGMANPICS[@turn]
    puts " #{@guess.join(' ')}"
    puts "\n"
    puts " #{@used_letter.join(' ')}"
    puts "\n"
  end

  def replay
    puts "Do you want to play again? [y/n]"
    answer = gets.chomp.downcase

    return unless answer == 'y'

    game_start
  end

  def game_loop
    @letter = gets.chomp.downcase

    until @gameover
      if @guess.include?(@letter)
        puts "You've already guessed that letter. Choose another:"
        @letter = gets.chomp.downcase
      elsif !@letter.match?(/[[:alpha:]]/)
        puts "Please choose a letter from A-Z"
        @letter = gets.chomp.downcase
      elsif @secret_word.include?(@letter)
        indexes = @secret_word.split('').each_index.select { |i| @secret_word[i] == @letter }
        indexes.each { |index| @guess[index] = @letter }
        print_gameboard

        if @guess.include?('_')
          puts "Choose another letter:"
          @letter = gets.chomp.downcase
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
          @used_letter.push(@letter)
          print_gameboard
          puts "Choose another letter:"
          @letter = gets.chomp.downcase
        end
      end
    end
  end

  def save_game

  end
end

new_game = Game.new
new_game.game_start
