class Admin::LayoutItemsController < AdminController
  def move
    LayoutItem.find(params[:id]).move(params[:direction].to_sym)
    redirect_to admin_layout_cells_url
  end
  
  def new
    layout_cell = LayoutCell.find(params[:layout_cell_id])
    render :partial => "form", :locals => {:layout_cell => layout_cell}
  end

  def create
    layout_cell = LayoutCell.find(params[:layout_cell_id])
    layout_cell.layout_items.create(params[:layout_item])
    redirect_to admin_layout_cells_url
    
  end

  def destroy
    LayoutItem.find(params[:id]).destroy
    redirect_to admin_layout_cells_url
  end

end
