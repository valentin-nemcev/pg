module LayoutGridHelper

  def sub_cols(grid, col_start, col_count)
    grid.inject([]) do |sub_grid, row|
      sub_grid << row[col_start, col_count]
    end
  end

  def render_grid_recur(grid, font_size_range)
    @rl ||= 0
    @rl += 1
    tables = ''
    row_num = 0
    while row_num < grid.length
      if grid[row_num].compact.empty?
        row_num += 1
        next
      end

      sub_rows_count = grid[row_num].compact.each.collect{|row| row.height rescue 1}.max
      sub_rows = grid[row_num, sub_rows_count]
      sub_row = sub_rows.first

      tr_contents = ''

      col_count = 0
      col_start = 0

      col_num = 0
      while col_num < sub_row.length
        cell = sub_row[col_num]

        is_last_cell = (col_num == sub_row.length-1)
        is_max_cell = (cell.height rescue 1) == sub_rows_count

        font_step = (font_size_range.last - font_size_range.first).fdiv(sub_row.length - 1)
        min_font = font_size_range.first - font_step
        font_range = (font_size_range.last - min_font)

        if is_max_cell or is_last_cell
          col_count += 1 if is_last_cell and not is_max_cell
          if col_count > 0
            sub_grid = sub_cols(sub_rows, col_start, col_count)
            td_width = 1.0/sub_row.length*(col_count)
            sub_font_size_range = Range.new(font_size_range.begin, font_size_range.begin+font_step*(col_count-1))
            c = @rl < 10 ? render_grid_recur(sub_grid, sub_font_size_range) : 'stop'
            tr_contents += content_tag('td', c, {:width => "#{td_width*100}%"})
          end
          col_count = 0
          col_start = col_num + (cell.width rescue 1)
        end
        if is_max_cell
          #if cell.kind_of? LayoutCell

            width = 100.0/sub_row.length*(cell.width rescue 1)
            font_size = min_font + font_range*width.to_f/100.0
            tr_contents += content_tag('td', render_cell(cell), {:width => "#{width}%", :style => "font-size: #{font_size}em"} )
          #end
          col_num += (cell.width rescue 1)
        else
          col_count += 1
          col_num += 1
        end

      end
      row_num += sub_rows_count
      tables += content_tag('table', tr_contents, {:class => "grid"}) unless tr_contents.empty?
    end
    @rl -= 1
    tables
  end

  def render_cell(cell)
    # h(cell.inspect)
    if cell.kind_of?(LayoutCell)
      cell.layout_items.inject('') do |html_str,content|
        html_str += if content.article.publicated?
                      render(
                             :partial => "site/article",
                             :locals => {:article => content.article, :with_category => true, :hide_date => true}
                             )
                    else
                      ""
                    end
      end
    else
       '&nbsp;'
    end
  end

  def render_grid(place, font_size_range)
    grid = LayoutCell.grid(place, :without_empty_row => true)
    content_tag('div', render_grid_recur(grid, font_size_range), {:class => "grid-container"})
  end

  def render_grid_old(place)
    grid = LayoutCell.grid(place)
    table_content = ''
    grid.each do |row|
      table_content << '<tr  style="height:100%">'
      row.each do |cell|
        next if cell.nil?
        if cell.kind_of?(LayoutCell)
          rowspan = cell.height
          colspan = cell.width
          td_content = h(cell.inspect)
        else
            rowspan, colspan = 1, 1
            td_content = '&nbsp;'
        end
        table_content << content_tag('td', td_content, {:colspan=>colspan, :rowspan=>rowspan,
                                 :width => "#{100/LayoutCell::COLUMN_COUNT[place]*colspan}%", :style => "height: 100px;"})
      end
    end
    content_tag('table', table_content, {:class => "grid #{place}", :style => "height: 100px;" })
  end

end
