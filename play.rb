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

def load_game
  game = Game.new
end


def menu
  puts "Welcome to Chess"
  puts "New game or Load game?"
  choice = gets.chomp.downcase
  if choice == "n"
    new_game
  elsif choice = "l"
    load_game
  end
end

menu
