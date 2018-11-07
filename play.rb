require_relative "lib/game"

def get_ai_color
  puts "Play as White or Black"
  choice = gets.chomp.downcase
  if choice == "w"
    return "black"
  elsif choice == "b"
    return "white"
  else
    get_ai_color
  end
end

def get_versus_ai
  puts "Versus Player or Computer"
  choice = gets.chomp.downcase
  if choice == "p"
    return false
  elsif choice == "c"
    return get_ai_color
  else
    get_versus_ai
  end
end

def new_game
  game = Game.new
  game.ai = get_versus_ai
  game.play_game
end

def load_menu
  if Dir["saves/*"] == []
    puts "No saved files!"
    puts "Starting New Game!"
    new_game
  else
    puts "Choose saved game number:"
    Dir["saves/*"].each_with_index { |save, i| puts "#{i + 1}: #{save[6..-5]}" }
    loadfile = Dir["saves/*"][gets.chomp.to_i - 1]
    puts "Loading #{loadfile[6..-5]}."
    game = Game.new
    game.load_game(loadfile)
    game.play_game
  end
end

def start
  puts "Welcome to Chess"
  print "New game or Load game? "
  choice = gets.chomp.downcase
  if choice == "n"
    new_game
  elsif choice == "l"
    load_menu
  end
end

start
