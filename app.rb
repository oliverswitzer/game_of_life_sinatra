require 'bundler'
Bundler.require


Dir.glob('./lib/*.rb') do |model|
  require model
end



module Name
  class App < Sinatra::Application
    @@game = Game.new(18, 30)
    @@game.pause = false
    # @@game.randomly_populate

    get '/' do
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph
      @game_over = ""
      erb :index
    end

    get '/window' do
      # puts @@game.pause
      @@game.world.next_frame!
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph
      @game_over = ""

      if @@game.static?
        @@game.pause = true
        @pause = "pause"
        @game_over = "<h1 style='position: absolute; left: 20px; top: 70px'>Game over: your cells have settled in for the long run! <a href='/start'>PLAY AGAIN</a></h1>"
      end

      if @world.tick_count >= 100
        @@game.pause = true
        @pause = "pause"
        winner = @@game.cell_majority_holder
        case winner
        when 1
          @game_over = "<h1 style='position: absolute; left: 20px; top: 70px'>Player 1 wins! <a href='/start'>PLAY AGAIN</a></h1>"
        when 2
          @game_over = "<h1 style='position: absolute; left: 20px; top: 70px'>Player 2 wins! <a href='/start'>PLAY AGAIN</a></h1>"
        when 0
          @game_over = "<h1 style='position: absolute; left: 20px; top: 70px'>Both players have the same amount of cells--it's a tie! <a href='/start'>PLAY AGAIN</a></h1>"
        end
      end
      
      erb :window
    end

    helpers do
      def color_cell(cell)
        if cell.alive?
          
          if cell.ownership == 1
            red_gradient
          elsif cell.ownership == 2
            blue_gradient
          else  #if ownership == 0, which should NEVER happen... EVER.
            "background-color: white"
          end
        else
          "background-color: black"
        end
      end

      def check_pause
        if @@game.pause == false 
          "<script>
            $(document).ready(function() {
              function loadNext() {
                $('#container').load('/window?randval='+ Math.random(), function() {
                  setTimeout(loadNext, 100);
                });
              }
            loadNext();
            });
            </script>"
          # "<meta http-equiv='refresh' content='0.1' >"
        else
          ""
        end
      end

      def reload_once
        if @reload == true
          "<script>
            window.onload = function() {
                if(!window.location.hash) {
                    window.location = window.location + '#loaded';
                    window.location.reload();
                }
            }
          </script>"
        else
          ""
        end
      end

      def red_gradient
        "background: rgb(243,197,189); /* Old browsers */
        background: -moz-linear-gradient(-45deg, rgba(243,197,189,1) 0%, rgba(232,108,87,1) 50%, rgba(234,40,3,1) 51%, rgba(255,102,0,1) 75%, rgba(199,34,0,1) 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, right bottom, color-stop(0%,rgba(243,197,189,1)), color-stop(50%,rgba(232,108,87,1)), color-stop(51%,rgba(234,40,3,1)), color-stop(75%,rgba(255,102,0,1)), color-stop(100%,rgba(199,34,0,1))); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(-45deg, rgba(243,197,189,1) 0%,rgba(232,108,87,1) 50%,rgba(234,40,3,1) 51%,rgba(255,102,0,1) 75%,rgba(199,34,0,1) 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(-45deg, rgba(243,197,189,1) 0%,rgba(232,108,87,1) 50%,rgba(234,40,3,1) 51%,rgba(255,102,0,1) 75%,rgba(199,34,0,1) 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(-45deg, rgba(243,197,189,1) 0%,rgba(232,108,87,1) 50%,rgba(234,40,3,1) 51%,rgba(255,102,0,1) 75%,rgba(199,34,0,1) 100%); /* IE10+ */
        background: linear-gradient(135deg, rgba(243,197,189,1) 0%,rgba(232,108,87,1) 50%,rgba(234,40,3,1) 51%,rgba(255,102,0,1) 75%,rgba(199,34,0,1) 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f3c5bd', endColorstr='#c72200',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */"
      end

      def blue_gradient
        "background: rgb(206,219,233); /* Old browsers */
        background: -moz-linear-gradient(-45deg, rgba(206,219,233,1) 0%, rgba(170,197,222,1) 17%, rgba(97,153,199,1) 34%, rgba(58,132,195,1) 47%, rgba(65,154,214,1) 59%, rgba(75,184,240,1) 71%, rgba(58,139,194,1) 84%, rgba(38,85,139,1) 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, right bottom, color-stop(0%,rgba(206,219,233,1)), color-stop(17%,rgba(170,197,222,1)), color-stop(34%,rgba(97,153,199,1)), color-stop(47%,rgba(58,132,195,1)), color-stop(59%,rgba(65,154,214,1)), color-stop(71%,rgba(75,184,240,1)), color-stop(84%,rgba(58,139,194,1)), color-stop(100%,rgba(38,85,139,1))); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(-45deg, rgba(206,219,233,1) 0%,rgba(170,197,222,1) 17%,rgba(97,153,199,1) 34%,rgba(58,132,195,1) 47%,rgba(65,154,214,1) 59%,rgba(75,184,240,1) 71%,rgba(58,139,194,1) 84%,rgba(38,85,139,1) 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(-45deg, rgba(206,219,233,1) 0%,rgba(170,197,222,1) 17%,rgba(97,153,199,1) 34%,rgba(58,132,195,1) 47%,rgba(65,154,214,1) 59%,rgba(75,184,240,1) 71%,rgba(58,139,194,1) 84%,rgba(38,85,139,1) 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(-45deg, rgba(206,219,233,1) 0%,rgba(170,197,222,1) 17%,rgba(97,153,199,1) 34%,rgba(58,132,195,1) 47%,rgba(65,154,214,1) 59%,rgba(75,184,240,1) 71%,rgba(58,139,194,1) 84%,rgba(38,85,139,1) 100%); /* IE10+ */
        background: linear-gradient(135deg, rgba(206,219,233,1) 0%,rgba(170,197,222,1) 17%,rgba(97,153,199,1) 34%,rgba(58,132,195,1) 47%,rgba(65,154,214,1) 59%,rgba(75,184,240,1) 71%,rgba(58,139,194,1) 84%,rgba(38,85,139,1) 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#cedbe9', endColorstr='#26558b',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */"
      end
    end


    get '/start' do
      #will contain the form 
      @world = @@game.world

      @@game.world.apocalypse
      @@game.world.tick_count = 0
      @@game.pause = false
      
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

    get '/pause' do
      @@game.pause = true
      @current_tick = @@game.world.tick_count
    end


    #helpers
    # helpers do
    #   def display_board

    #   end
    # end

  end
end
