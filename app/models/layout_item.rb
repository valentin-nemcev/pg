class LayoutItem < ActiveRecord::Base


  def self.hash_2d
    hash_2d = {}
    self.all.each do |item|
      hash_2d[[item.top,item.left]] = item
    end
    hash_2d
  end
  
  def self.grid
    hash_2d = LayoutItem.hash_2d
    rows, cols = 5,5
    grid = Array.new(rows) {Array.new(cols, 'empty')}
    logger.info(grid.inspect)
    grid.each_with_index do |row, y| 
      next if row.nil?
      row.each_index do |x| 
        if item = hash_2d[[y,x]]
          grid.fill(item.top,item.height) do |sub_y|
            logger.info(grid.inspect)
            logger.info { sub_y } 
            next if grid[sub_y].nil?
            grid[sub_y].fill(item.left,item.width) do 
              'full'
            end
          end
          
          grid[y][x] =  item.place
        end
      end 
    end
    logger.info(grid.inspect)
    grid.compact!
  end


end
