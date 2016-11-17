require 'yaml'

class Hangman
  attr_reader :word, :word_progress, :incorrect_guesses, :current_guess

  def initialize
    new_word
    puts @word
    new_game
  end

  private 

  def new_word
  	@word = "nope"
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

  def new_game
  	guesses = 9
  	@current_guess = ""
  	@word_progress = []
  	@incorrect_guesses = []
  	(@word.length).times do
  	  @word_progress.push("_")
  	end
  	until @current_guess.downcase == @word.downcase || @word_progress.join == @word || guesses == 0  
      puts "Incorrect guesses: #{incorrect_guesses.join(',')}"
      puts word_progress.join
  	  puts "Please enter your next guess. You have #{guesses} guesses left."
  	  @current_guess = gets.chomp
  	  guesses -= 1
  	  update_progress
  	end
  	if @current_guess.downcase == @word.downcase || @word_progress.join == @word
  	  puts "Congratulations! You solved the word #{@word}!"
  	else
  	  puts "Sorry, you're out of guesses. The word was #{@word}."
  	end
  end

  def update_progress
  	valid = false
  	until valid
  	  if @current_guess.length == 1
  	  	single_letter_guess
  	  	valid = true
  	  elsif @current_guess.length == @word.length
  	    unless @current_guess.downcase == @word.downcase
  	  	  @incorrect_guesses.push(@current_guess.downcase)
  	    end
  	    valid = true
  	  else
		puts "Invalid guess. Please enter either a letter or a word to guess."  	  	
  	    @current_guess = gets.chomp
  	  end
  	end
  end

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
end

game = Hangman.new