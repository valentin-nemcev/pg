class Admin::LayoutItemsController < AdminController
  def move
    layout_item = LayoutItem.find(params[:id])
    case params[:direction].to_sym
    when :up  then layout_item.move_higher
    when :down then layout_item.move_lower
    end

    redirect_to admin_layout_cells_url
  end
  
  def new
    layout_cell = LayoutCell.find(params[:layout_cell_id])
    render :partial => "form", :locals => {:layout_cell => layout_cell}
  end

  def create
    layout_cell = LayoutCell.find(params[:layout_cell_id])
    layout_cell.layout_items.create(params[:layout_item]).move_to_top
    redirect_to admin_layout_cells_url
    
  end

  def destroy
    LayoutItem.find(params[:id]).destroy
    redirect_to admin_layout_cells_url
  end

end
