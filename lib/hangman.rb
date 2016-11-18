require 'yaml'

class Hangman
  attr_reader :word, :word_progress, :incorrect_guesses, :current_guess, :guesses

  def initialize
  	puts "The game is Hangman! If you don't know how it works look it up."
    menu
  end

  def menu
  	puts "Enter 'new' for a new game, 'load' to load a saved game, 'delete' to delete a save file or 'quit' to quit the game."
  	input = gets.chomp.downcase 
  	case input
  	  when "new"
  	  	new_game_setup
  	  when "load"
  	  	load_game
  	  when "quit"
  	  	puts "Thanks for playing."
  	  when "delete"
  	  	delete_game
  	  else
  	  	puts "Invalid input"
  	  	menu
  	end
  end

  def new_word
  	possible_words = []
  	File.open('5desk.txt','r') do |word_file|
  	  word_file.each_line do |words|
  	    if words.strip.length > 4 and words.strip.length < 13
  	      possible_words.push(words)
  	    end
  	  end
  	end
  	@word = possible_words.sample.strip
  end

  def game_turn
  	if @current_guess.downcase == @word.downcase || @word_progress.join == @word
  	  puts "Congratulations! You solved the word #{@word}!"
  	elsif @guesses == 0
  	  puts "Sorry, you're out of guesses. The word was #{@word}."
    else
      puts "Incorrect guesses: #{incorrect_guesses.join(',')}"
      puts word_progress.join
  	  puts "Please enter your next guess. You have #{guesses} guesses left."
  	  @current_guess = gets.chomp
  	  update_progress
  	end
  end

  def new_game_setup
    new_word
  	@guesses = 9
  	@current_guess = ""
  	@word_progress = []
  	@incorrect_guesses = []
  	(@word.length).times do
  	  @word_progress.push("_")
  	end
  	game_turn
  end 

  def update_progress
  	if @current_guess.length == 1
  	  if @incorrect_guesses.include?(@current_guess.downcase)
  	  	puts "You already guessed that letter"
  	  else
        single_letter_guess
        @guesses -= 1
      end
      game_turn
  	elsif @current_guess.length == @word.length
  	  unless @current_guess.downcase == @word.downcase
  	  	@incorrect_guesses.push(@current_guess.downcase)
  	  end
  	  @guesses -= 1
  	  game_turn
  	elsif @current_guess.downcase.strip == "save"
  	  save_game
  	  puts "Your game has been saved sucessfully!\n"
  	  menu
  	else
      puts "Invalid guess. Please enter either a letter or a word to guess."
      game_turn  	  	
  	end
  end

  private 

  def single_letter_guess
    if letter_in_word
  	  @word.split('').each_with_index do |letter,index|
  	  	if @current_guess == letter.downcase
  	  	  @word_progress[index] = letter
  	  	end
  	  end
  	else
      @incorrect_guesses.push(@current_guess)
  	end
  end

  def letter_in_word
  	@word.split('').any? do |letter|
      @current_guess == letter.downcase
    end
  end

  def save_game
    yaml = YAML::dump(self)
    puts 'Please enter a save file name (no spaces).'
    save = gets.strip.split(" ")[0]
    save_file = File.new("saves/#{save}.yaml", 'w')
    File.write("saves/#{save}.yaml",yaml)
  end

  def load_game
  	puts "Select a save file to load."
    saves = Dir.glob('saves/*')
    saves.each_with_index do |file,index|
      puts "#{index}. #{file}"
    end
    file_index = gets.chomp
    load_file = YAML::load(File.open(saves[file_index.to_i]))
    load_file.game_turn
  end

  def delete_game
    puts "Select a save file to delete."
    saves = Dir.glob('saves/*')
    saves.each_with_index do |file,index|
      puts "#{index}. #{file}"
    end
    file_index = gets.chomp
    puts "Are you sure you want to delete #{saves[file_index.to_i]}? (yes/no)"
    choice = gets.chomp.downcase
    if choice == "yes"
      File.delete(saves[file_index.to_i])
      puts "File deleted successfully!"
    elsif choice == "no"
      puts "No files deleted."
    else
      puts "Invalid input"
    end
    menu
  end
end

Hangman.new




