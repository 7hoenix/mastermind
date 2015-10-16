def navigator(first_time=false)
  if first_time
    puts "Would you like to (p)lay, read the (i)nstructions, or (q)uit?"
  else
    puts "Do you want to (p)lay again or (q)uit?"
  end

  answer = gets.chomp.downcase

  if answer == "p" || answer == "play"
    play_game
  elsif answer == "i" || answer == "instructions"
    show_instructions
  elsif answer == "q" || answer == "quit"
    return
  else
    puts "Didn't quite catch that"
    navigator
  end
end

def quitting?(guess)
  if guess == "q" || guess == "quit"
    puts "Quitters never win"
    @key, @guess_counter = nil
    navigator
  end
end

def generate_key
  colors = ["r", "g", "b", "y"]
  key = []
  4.times { key << colors.sample }
  key
end

def cheating?(guess)
  if guess == "c" || guess == "cheat"
    puts @key.join
  end
end

def valid?(guess)
  if guess.length < 4
    puts "Too short"
  elsif guess.length > 4
    puts "Too long"
  end
end

def correct_element?(guess)
  element_counter = 0
  guess.chars.each do |char|
    element_counter += 1 if @key.include?(char)
  end
  element_counter
end

def correct_position?(guess)
  position_counter = 0
  guess.chars.each_with_index do |char, index|
    position_counter += 1 if char == @key[index]
  end
  position_counter
end

def correct?(guess)
  true if guess == @key.join
end

def elapsed_time(timer)
  time = Time.now - timer
  minutes = time.to_i / 60
  seconds = time.to_i % 60
  return minutes, seconds
end

def play_game
  @key = generate_key
  @guess_counter = 0
  timer = Time.now
  loop do
    if @guess_counter == 0
      puts "I have generated a beginner sequence with four elements made up of: (r)ed,
      (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.
      What's your guess?"
    else
      puts "#{@guess.upcase} has #{@correct_elements} of the correct elements
      with #{@correct_positions} in the correct positions."
    end
    @guess = gets.chomp.downcase

    quitting?(@guess)
    cheating?(@guess)
    valid?(@guess)
    @correct_elements  = correct_element?(@guess)
    @correct_positions = correct_position?(@guess)
    @guess_counter += 1
    break if correct?(@guess)
  end
  minutes, seconds = elapsed_time(timer)
  puts "Congratulations! You guessed the sequence #{@key.join} in #{@guess_counter} guesses over #{minutes} minutes, #{seconds} seconds."

  navigator
end

def show_instructions
  puts "A random key will be generated. Your job is to guess what it is. Enter
  your guess and then the system will tell you how many are in the correct
  position and how many are the correct element."
  navigator
end

navigator(true)
