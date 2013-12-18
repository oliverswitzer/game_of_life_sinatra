require 'bundler'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Name
  class App < Sinatra::Application
    @@game = Game.new(20)
    @@game.pulsar

    get '/' do
      @@game.world.next_frame!
      @local_game = @@game
      @world = @local_game.world
      @graph = @world.graph
      @green = "background-color: green"
      @black = "background-color: black"
      
      erb :index
    end


    get '/start' do
      #will contain the form 
      @graph = @@game.world.graph

      erb :start
    end

    post '/play' do
      #will be passed the params to tell which cells are to be started


      erb :play
    end


    #helpers
    # helpers do
    #   def display_board

    #   end
    # end

  end
end
