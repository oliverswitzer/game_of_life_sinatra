
require_relative 'world'

class Cell

  attr_accessor :x, :y, :world, :alive 

  def initialize(world, x=0,y=0)
    @x = x
    @y = y
    @world = world
    @alive = false
    world.cells << self
  end

  def neighbors
    @neighbors = []
    world.cells.each do |cell|
      if cell.alive?
        # Check for North neighbor
        if cell.x == self.x && cell.y == self.y + 1
          @neighbors << cell
        # Check for North East neighbor
        elsif cell.x == self.x + 1 && cell.y == self.y + 1
          @neighbors << cell
        # East neighbor
        elsif cell.x == self.x + 1 && cell.y == self.y
          @neighbors << cell
        # South East neighbor
        elsif cell.x == self.x + 1 && cell.y == self.y - 1
          @neighbors << cell
        # South neighbor
        elsif cell.x == self.x && cell.y == self.y - 1
          @neighbors << cell
        # South West neighbor
        elsif cell.x == self.x - 1 && cell.y == self.y - 1
          @neighbors << cell
        # West neighbor
        elsif cell.x == self.x - 1 && cell.y == self.y
          @neighbors << cell
        # North West nieghbor
        elsif cell.x == self.x - 1 && cell.y == self.y + 1
          @neighbors << cell
        end
      end
    end
    @neighbors
  end

  def dead?
    !@alive   # world does not include this instance?
  end

  def alive?
    @alive   #world does include this instance?
  end

  def spawn_at(x, y)
    world.graph[x][y].alive = true
    return world.graph[x][y]
  end

  def die!
    @alive = false 
  end

  def birth!
    @alive = true
  end

end
