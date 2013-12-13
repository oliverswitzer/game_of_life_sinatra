require 'bundler'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Name
  class App < Sinatra::Application
    @@game = Game.new
    @@game.randomly_populate

    get '/' do
      @@game.world.next_frame!
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph
      @green = "background-color: green"
      @black = "background-color: black"
      
      erb :index
    end

    #helpers
    # helpers do
    #   def display_board

    #   end
    # end

  end
end
