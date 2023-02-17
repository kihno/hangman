def get_random_word
  all_words = []
  File.readlines('google-10000-english.txt').each { |word| all_words << word.chomp }

  all_words.select { |word| word.length > 5 && word.length < 12 }.sample
end

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
