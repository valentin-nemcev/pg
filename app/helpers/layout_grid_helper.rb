module LayoutGridHelper
  def render_grid(place)
    grid = LayoutItem.grid(place)
    table_content = ''
    grid.each do |row|
      table_content << '<tr>'
      row.each do |cell|
        if cell.kind_of?(LayoutItem) and not cell.content.nil?
          rowspan = cell.height
          colspan = cell.width
          td_content = render(:partial => "site/layout_grid/#{cell.content_type.downcase}", :locals => {:content => cell.content})
        else
            rowspan, colspan = 1, 1
            td_content = '&nbsp;'
        end
        table_content << content_tag('td', td_content, {:colspan=>colspan, :rowspan=>rowspan, 
                                 :width => "#{100/LayoutItem::ColumnCount[place]*colspan}%"})
      end
    end
    content_tag('table', table_content, :class => "grid #{place}")
  end
    
end
