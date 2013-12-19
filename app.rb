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
      @game_over = ""

      if @world.tick_count >= 100
        @pause = true
        p1_cells = []
        p2_cells = []
        @world.cells.each do |cell|   #count each players cells
          if cell.ownership == 1 
            p1_cells << cell
          elsif cell.ownership == 2
            p2_cells << cell
          else
            nil
          end
          p1_count = p1_cells.count
          p2_count = p2_cells.count
          case (p1_count <=> p2_count)
          when 1
            @game_over = "Player 1 wins! <a href='/start'>PLAY AGAIN</a>"
          when -1
            @game_over = "Player 2 wins! <a href='/start'>PLAY AGAIN</a>"
          when 0
            @game_over = "Both players have the same amount of cells--it's a tie! <a href='/start'>PLAY AGAIN</a>"
          end
        end
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
