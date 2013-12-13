require_relative 'cell'

class World

  attr_accessor :cells, :size, :graph

  def initialize(size)
    @size = size
    @cells = []
    @graph = []
    populate
  end

  def populate
    size.times do |x|
      @graph << []
      size.times do |y|
        @graph[x] << Cell.new(self, x, y)
      end
    end
  end

  def birth_cell(x, y)
    graph[x][y].alive = true
    return graph[x][y]
  end

  def cell_at(x, y)
    return graph[x][y]
  end

  def next_frame!
    dead_array = []
    alive_array = []
    cells.each do |cell|
      if cell.dead? && cell.neighbors.count == 3
        alive_array << cell
      elsif cell.alive? && cell.neighbors.count < 2
        dead_array << cell
      elsif cell.alive? && cell.neighbors.count > 3
        dead_array << cell
      end
    end
    dead_array.each { |cell| cell.die! }
    alive_array.each { |cell| cell.birth!}
  end
end

