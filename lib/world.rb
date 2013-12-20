require_relative 'cell'

class World

  attr_accessor :cells, :size_x, :size_y, :graph, :tick_count, :new_cells_per_tick

  def initialize(size_x, size_y)
    @tick_count = 1
    @size_x = size_x
    @size_y = size_y
    @cells = []
    @graph = []
    populate
    @new_cells_per_tick = []
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

  def birth_cell(x, y, player)
    cell = graph[x][y]
    cell.alive = true
    cell.ownership = player
    return cell
  end

  def cell_at(x, y)
    return graph[x][y]
  end

  def decide_ownership(cell)
    player1 = []
    player2 = []
    cell.neighbors.each do |cell|
      if cell.ownership == 1
        player1 << cell
      elsif cell.ownership == 2
        player2 << cell
      else
        nil
      end
    end
    player1_total = player1.count
    player2_total = player2.count
    

    case (player1_total <=> player2_total)
    when 1    #when +1, player1 wins
      1
      # puts "player1"
      # puts "#{player1_total <=> player2_total}"
    when -1    #when -1 player 2 wins
      2 
      # puts "player2"
      # puts "#{player1_total <=> player2_total}"
    end
  end



  def next_frame!
    dead_array = []
    alive_array = []
    cells.each do |cell|
      if cell.dead? && cell.neighbors.count == 3
        cell.future_ownership = decide_ownership(cell)
        alive_array << cell
      elsif cell.alive? && cell.neighbors.count < 2
        dead_array << cell
      elsif cell.alive? && cell.neighbors.count > 3
        dead_array << cell
      end
    end

    @new_cells_per_tick << alive_array.count

    dead_array.each do |cell| 
      cell.die!
      cell.ownership = 0 
    end

    alive_array.each do |cell| 
      cell.birth!
      if cell.future_ownership == 1
        cell.ownership = 1
      elsif cell.future_ownership == 2
        cell.ownership = 2
      else
        cell.ownership = 0
      end
    end

    @tick_count += 1
  end
end

