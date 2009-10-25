module Admin::LayoutCellsHelper
  def td_size(cell, columns_count)
    {
      :width => (100/5*cell.width).to_s+'%', 
      :rowspan => cell.height,
      :colspan => cell.width,
    }
  end
  
  def get_side_arrow(side)
    arrows = {
      [:left, :inc]=>'→', [:left, :dec]=>'←', 
      [:top, :inc]=>'↓', [:top, :dec]=>'↑', 
      [:right, :inc]=>'→', [:right, :dec]=>'←', 
      [:bottom, :inc]=>'↓', [:bottom, :dec]=>'↑', 
    } 
    arrows[[side[:side], side[:direction]]]
  end
  
  def move_side_link(cell, side)
    
    # link_to(get_side_arrow(side), move_side_admin_layout_cell_path(cell, side), :class => 'button') if cell.can_move_side?(side[:direction], side[:side])
  end
  
end
