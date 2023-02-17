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

  def game_start
    @secret_word = get_random_word
    @turn = 0
    @guess = Array.new(@secret_word.length, '_')

    puts "Welcome to Hangman"
    puts HANGMANPICS[@turn]
    puts "  #{@guess.join(' ')}"
    puts "\n"
  end

  def game_loop
    
  end

  def save_game

  end
end

new_game = Game.new
new_game.game_start
