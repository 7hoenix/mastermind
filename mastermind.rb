
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

def difficulty?(flash=true)
  puts "Didn't quite catch that" if flash
  puts "What difficulty do you want to play at?
  (B)eginner: 4 characters, 4 colors
  (I)ntermediate: 6 characters, 5 colors
  (A)dvanced: 8 characters, 6 colors"
  a = gets.chomp.downcase
  if a == "b" || a == "beginner" || a == "i" || a == "intermediate" || a == "a" || a == "advanced"
    a.chars.pop
  else
    difficulty?(true)
  end
end

def generate_key(difficulty)
  key = []
  if difficulty == "b"
    colors = ["r", "g", "b", "y"]
    4.times { key << colors.sample }
  elsif difficulty == "i"
    colors = ["r", "g", "b", "y", "p"]
    6.times { key << colors.sample }
  elsif difficulty == "a"
    colors = ["r", "g", "b", "y", "p", "f"]
    8.times { key << colors.sample }
  end
  key
end

def colors_list(difficulty)
  if difficulty == "b"
    return 4, "(r)ed, (g)reen, (b)lue, (y)ellow"
  elsif difficulty == "i"
    return 5, "(r)ed, (g)reen, (b)lue, (y)ellow, (p)ink"
  elsif difficulty == "a"
    return 6, "(r)ed, (g)reen, (b)lue, (y)ellow, (p)ink, (f)ushcia"
  end
end

def cheating?(guess)
  if guess == "c" || guess == "cheat"
    puts @key.join
  end
end

def valid?(guess, difficulty)
  if difficulty == "b"
    if guess.length < 4
      puts "Too short"
    elsif guess.length > 4
      puts "Too long"
    end
  elsif difficulty == "i"
    if guess.length < 6
      puts "Too short"
    elsif guess.length > 6
      puts "Too long"
    end
  elsif difficulty == "a"
    if guess.length < 8
      puts "Too short"
    elsif guess.length > 8
      puts "Too long"
    end
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

def compare_to_others(hashy_hash)
  require "json"
  File.open("results.json", "w") do |f|
    f.write(hashy_hash.to_json)
  end

  file = File.read("results.json")
  data_hash = JSON.parse(file)
  time_sum = 0
  guesses_sum = 0
  data_hash.each do ||
    time_sum += k
    guesses_sum += v
  end

  avg_time  = time_sum / data_hash.length
  avg_guesses = guesses_sum / data_hash.length
  return (avg_time - time), (avg_guesses - guesses)
end

def play_game
  difficulty_level = difficulty?
  @key = generate_key(difficulty_level)
  @guess_counter = 0
  timer = Time.now
  loop do
    if @guess_counter == 0
      number, text = colors_list(difficulty_level)
      puts "I have generated a sequence with #{number} elements made
      up of: #{text}. Use (q)uit at any time to end the game.
      What's your guess?"
    else
      puts "#{@guess.upcase} has #{@correct_elements} of the correct elements
      with #{@correct_positions} in the correct positions.
      You've taken #{@guess_counter} guess"
    end
    @guess = gets.chomp.downcase

    quitting?(@guess)
    cheating?(@guess)
    valid?(@guess, difficulty_level)
    @correct_elements  = correct_element?(@guess)
    @correct_positions = correct_position?(@guess)
    @guess_counter += 1
    break if correct?(@guess)
  end
  minutes, seconds = elapsed_time(timer)
  puts "Congratulations! You've guessed the sequence! What's your name?"
  name = gets.chomp

  jsony = { name: name,
            minutes: minutes,
            seconds: seconds,
            guesses: @guess_counter }
  results = compare_to_others(jsony)

  # puts "Congratulations! You guessed the sequence #{@key.join} in #{@guess_counter} guesses over #{minutes} minutes, #{seconds} seconds."

  navigator
end

def show_instructions
  puts "A random key will be generated. Your job is to guess what it is. Enter
  your guess and then the system will tell you how many are in the correct
  position and how many are the correct element."
  navigator
end

navigator(true)
