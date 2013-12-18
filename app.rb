require 'bundler'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Name
  class App < Sinatra::Application
    @@game = Game.new(25, 57)

    get '/' do
      @pause = false
      @@game.world.next_frame!
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph
      @green = "background-color: green"
      @black = "background-color: blue"

      if @world.tick_count == 10
        @pause = true
      end
      
      erb :index
    end


    get '/start' do
      #will contain the form 
      @world = @@game.world

      @@game.world.apocalypse
      @@game.world.tick_count = 0
      
      @graph = @world.graph
      erb :start
    end

    post '/play' do
      #will be passed the params to tell which cells are to be started
      # "[6, 14]"
      to_live = []
      params.values.each do |str_coordinate|
        str_array = str_coordinate.gsub("[","").gsub("]", "").split(",")
        int_coord = str_array.collect { |coord| coord.to_i }
        to_live << int_coord
      end

      @@game.world.cells.each do |cell|
        if to_live.include?([cell.x, cell.y])
          cell.alive = true
        end
      end

      erb :play
    end


    #helpers
    # helpers do
    #   def display_board

    #   end
    # end

  end
end
