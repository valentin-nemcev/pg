class LayoutCell < ActiveRecord::Base

  has_many :layout_items, :order => 'position ASC', :dependent => :destroy
  #accepts_nested_attributes_for :content, :reject_if => proc { |attrs| attrs['article_id'].blank? }

  has_many :articles, :through => :content
  # belongs_to :content, :polymorphic => true

  PLACES = %w{main sidebar}
  COLUMN_COUNT = {'main' => 5, 'sidebar' => 2}
  DIRECTIONS = {:inc => +1, :dec => -1}

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

    def grid(place, options = {})
      items = self.find_all_by_place(place, :include  => {:layout_items => {:article => :tags}})
      hash_2d = self.hash_2d(items)
      cols = COLUMN_COUNT[place]
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
      grid.compact!
      grid = grid << ([:empty]*cols) unless options[:without_empty_row]
      # logger.info(grid.inspect)
      items.each { |itm| itm.set_neighbours(grid)}
      return grid
    end

  end


  def set_neighbours(grid)
    @neighbours_present = {}

    # top_row = grid.fetch(self.top-1, [])[self.left...self.right]
    # @neighbours_present[:top] = !top_row.nil? && top_row.all?{|cell| cell == :empty}
    @neighbours_present[:top] = if self.top > 0
      grid[self.top-1][self.left...self.right].all? {|cell| cell == :empty}
    else
      false
    end

    bottom_row = grid.fetch(self.bottom, [])[self.left...self.right]
    @neighbours_present[:bottom] = !bottom_row.nil? && bottom_row.all?{|cell| cell == :empty}

    @neighbours_present[:left] = if self.left > 0
      grid[self.top...self.bottom].map{|row| row[self.left-1] }.all?{|cell| cell == :empty}
    else false  end

    @neighbours_present[:right] = grid[self.top...self.bottom].map{|row| row[self.right] }.all?{|cell| cell == :empty}

  end

  def side_free?(side)
    @neighbours_present.nil? ? true : @neighbours_present[side]
  end

  def can_move_side?(direction, side)
    delta = DIRECTIONS[direction]

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
    delta = DIRECTIONS[direction]

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
      self.place = PLACES[0] until PLACES.include? self.place
    end

    def validate_size_and_pos
      col_border = COLUMN_COUNT[self.place]-1
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
      not self.intersects_with?(self.class.find_all_by_place(self.place))
    end

    def intersects_with?(items)
      items.any? do |item|
        self != item and self.place == item.place and
          (self.left<item.right and self.right>item.left) and
          (self.top<item.bottom and self.bottom>item.top)
      end
    end

end
