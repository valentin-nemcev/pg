class LayoutItem < ActiveRecord::Base

  belongs_to :content, :polymorphic => true

  Places = %w{main sidebar}
  ColumnCount = {'main' => 5, 'sidebar' => 2}
  
  validate :item_place, :item_size_and_pos

  def self.grid_height(place)
    self.find_all_by_place(place).map{|item| item.top + item.height }.max.to_i
  end
  
  def self.hash_2d(place)
    hash_2d = {}
    self.find_all_by_place(place).each do |item|
      hash_2d[[item.top,item.left]] = item
    end
    hash_2d
  end
  
  def self.grid(place)
    hash_2d = self.hash_2d(place)
    cols = ColumnCount[place]
    rows = self.grid_height(place)
    grid = Array.new(rows) {Array.new(cols, 'empty')}
    grid.each_with_index do |row, y| 
      row.each_index do |x| 
        if item = hash_2d[[y,x]]
          grid.fill(item.top, item.height) do |sub_y|
            grid[sub_y].fill(nil, item.left,item.width) unless grid[sub_y].nil?
          end
          grid[y][x] = item
        end
      end unless row.nil? # row.each_index
    end
    # logger.info(grid.inspect)
    grid.compact.map(&:compact)
  end

  protected
    
    def item_place
      self.place = Places[0] until Places.include? self.place
    end
    
    def item_size_and_pos
      col_border = ColumnCount[self.place]-1
      self.left ||= 0
      self.top ||= 0
      self.width ||= 0
      self.height ||= 0 
      
      self.left = 0 if self.left < 0
      self.left = col_border if self.left > col_border
      
      self.top = 0 if self.top < 0
      
      self.width = 1 if self.width < 1
      self.width = (col_border+1)-self.left if self.left+self.width > col_border+1
      
      self.height = 1 if self.height < 1
      return true
    end

end
