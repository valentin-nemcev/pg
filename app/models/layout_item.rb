class LayoutItem < ActiveRecord::Base

  has_many :content, :class_name => 'LayoutItemsToContent', :order => 'position ASC', :dependent => :destroy
  accepts_nested_attributes_for :content, :reject_if => proc { |attrs| attrs['article_id'].blank? }
   
  has_many :articles, :through => :content
  # belongs_to :content, :polymorphic => true

  Places = %w{main sidebar}
  ColumnCount = {'main' => 5, 'sidebar' => 2}
  Directions = {:inc => +1, :dec => -1}
  
  before_save :validate_place, :validate_size_and_pos, :validate_intersections

  class << self
    def grid_height(items)
      items.map{|item| item.top + item.height }.max.to_i
    end

    def hash_2d(items)
      hash_2d = {}
      items.each do |item|
        hash_2d[[item.top,item.left]] = item
      end
      hash_2d
    end

    def grid(place)
      items = self.find_all_by_place(place)
      hash_2d = self.hash_2d(items)
      cols = ColumnCount[place]
      rows = self.grid_height(items)
      grid = Array.new(rows) {Array.new(cols, :empty)}
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
      grid = grid.compact << ([:empty]*cols)
      items.each { |itm| itm.set_neighbours(grid)}
      return grid
    end
  
  end


  def set_neighbours(grid)
    @neighbours_present = {}
    @neighbours_present[:top] = if self.top > 0
      grid[self.top-1][self.left...self.right].all? {|cell| cell == :empty}
    else false  end
      
    @neighbours_present[:bottom] = grid.fetch(self.bottom, [])[self.left...self.right].all?{|cell| cell == :empty}
    
    @neighbours_present[:left] = if self.left > 0
      grid[self.top...self.bottom].map{|row| row[self.left-1] }.all?{|cell| cell == :empty}
    else false  end  
    
    @neighbours_present[:right] = grid[self.top...self.bottom].map{|row| row[self.right] }.all?{|cell| cell == :empty} 
    
  end

  def side_free?(side)
    @neighbours_present.nil? ? true : @neighbours_present[side] 
  end

  def can_move_side?(direction, side)
    delta = Directions[direction]
      
    case side
    when :top
      (self.height - delta) > 0 and (direction == :dec ? side_free?(:top) : true)
    when :left
      (self.width - delta) > 0 and (direction == :dec ? side_free?(:left) : true)
    when :bottom
      (self.height + delta) > 0 and (direction == :inc ? side_free?(:bottom) : true)
    when :right
      (self.width + delta) > 0 and (direction == :inc ? side_free?(:right) : true)
    end
  
  end 

  def move_side(direction, side)
    delta = Directions[direction]
      
    case side
    when :top
      if (self.height - delta) > 0
        self.top += delta
        self.height -= delta
      end
    when :left
      if (self.width - delta) > 0
        self.left += delta
        self.width -= delta
      end
    when :bottom
      self.height += delta
    when :right
      self.width += delta
    end
  end
  
  def right
    self.left + self.width
  end
  
  def bottom
    self.top + self.height
  end
  
  protected
    
    def validate_place
      self.place = Places[0] until Places.include? self.place
    end
    
    def validate_size_and_pos
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
    
    def validate_intersections
      not self.intersects_with?(LayoutItem.find_all_by_place(self.place))
    end
    
    def intersects_with?(items)
      items.any? do |item|
        self != item and self.place == item.place and
          (self.left<item.right and self.right>item.left) and 
          (self.top<item.bottom and self.bottom>item.top)
      end
    end
    
end
