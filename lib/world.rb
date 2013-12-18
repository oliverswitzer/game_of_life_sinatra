require_relative 'cell'

class World

  attr_accessor :cells, :size_x, :size_y, :graph, :tick_count

  def initialize(size_x, size_y)
    @tick_count = 1
    @size_x = size_x
    @size_y = size_y
    @cells = []
    @graph = []
    populate
  end

  def apocalypse
    cells.each do |cell|
      cell.alive = false
    end
  end

  def populate
    size_x.times do |x|
      @graph << []
      size_y.times do |y|
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
    @tick_count += 1
  end
end

