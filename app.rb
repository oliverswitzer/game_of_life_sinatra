require 'bundler'
Bundler.require


Dir.glob('./lib/*.rb') do |model|
  require model
end



module Name
  class App < Sinatra::Application
    @@game = Game.new(18, 30)
    # @@game.randomly_populate

    get '/' do
      @pause = false
      
      @@game.world.next_frame!
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph

      if @world.tick_count == 100
        @pause = true
      end
      
      erb :index
    end

    helpers do
      def color_cell(cell)
        if cell.alive?
          
          if cell.ownership == 1
            
            "background-color: red"
          elsif cell.ownership == 2
            
            "background-color: blue"
          else  #if ownership == 0, which should NEVER happen... EVER.
            "background-color: white"
          end
        else
          "background-color: black"
        end
      end
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
        if str_coordinate[0] == "["
          str_array = str_coordinate.gsub("[","").gsub("]", "").split(",")
          int_coord = str_array.collect { |coord| coord.to_i }
          to_live << int_coord
          puts ""
        end
      end

      @@game.world.cells.each do |cell|
        if to_live.include?([cell.x, cell.y])
          cell.alive = true
          cell.ownership = params["player"].to_i
          puts ""
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
