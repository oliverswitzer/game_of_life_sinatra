# require './gosu_viz'
require_relative 'world'


class Game

  attr_accessor :world, :viz_app

  def initialize size_x=20, size_y=20
    @world = World.new(size_x, size_y)
  end
  
  def print_world
    @world.graph.each do |x|
      puts
      x.each do |cell|
        if cell.alive? 
          print " * "
        else
          print " . "
        end
      end
    end
  end


  def set_game_params
    params = viz_app.get_user_params

    # set initial conditions
    case params[:game_type]
    when 'rand'
      randomly_populate
    when 'blinker'
      blinker
    when 'pulsar'
      pulsar
    end

    # set frame rate of terminal app 
    @viz_app.frame_time = params[:frame_time]
  end

  def run_with_terminal 
    @viz_app = TerminalViz.new
    @viz_app.world = @world
    set_game_params
    @viz_app.run
  end

  def run_with_gosu
    exec("ruby gosu_viz.rb")
    # @viz_app = ::GosuViz.new
    # @viz_app.world = @world
  end

  def term_or_gosu_prompt
    puts "Would you like to vizualize this Game of Life in Terminal or in Gosu? (type 'terminal' or 'gosu')"
    inp = gets.chomp.downcase
    unless ['terminal', 'gosu'].include? inp
      puts "*** Input not recognized! ***"
      term_or_gosu_prompt
    end
    return inp
  end

  def run
    inp = term_or_gosu_prompt
    if inp == 'terminal' 
      run_with_terminal
    elsif inp == 'gosu'
      run_with_gosu
    else
      raise "Vizualization object not recognized"
    end
  end

  # Custom beginning states for terminal Game of Life
  def blinker
    world.birth_cell(10, 9)
    world.birth_cell(10, 10)
    world.birth_cell(10, 11)
  end

  def pulsar 
    world.birth_cell(10, 7)
    world.birth_cell(9, 8)
    world.birth_cell(11, 8)
    world.birth_cell(9, 9)
    world.birth_cell(11, 9)
    world.birth_cell(10, 10)
    world.birth_cell(9, 11)
    world.birth_cell(11, 11)
    world.birth_cell(9, 12)
    world.birth_cell(11, 12)
    world.birth_cell(10, 13)
  end

  def randomly_populate
    rand(1..world.size_x**2).times do 
      world.birth_cell(rand(0..world.size_x-1), rand(0..world.size_x-1), rand(1..2))
    end
  end

end




