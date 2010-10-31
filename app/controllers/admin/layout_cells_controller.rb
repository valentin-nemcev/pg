class Admin::LayoutCellsController < AdminController
  def index
    @layout_cells = LayoutCell.find(:all)
    render :action => "index"
  end
  
  def move_side
    cell = LayoutCell.find(params[:id])
    cell.move_side(params[:direction].to_sym, params[:side].to_sym)
    cell.save
    redirect_to admin_layout_cells_url
  end
  
  
  def create
    @layout_cell = LayoutCell.new(params[:layout_cell])

    if @layout_cell.save
      
      redirect_to admin_layout_cells_url
    else
      @layout_cell = LayoutCell.find(:all)
      render :action => "index"
    end
  end

  def update
    @layout_cell = LayoutCell.find(params[:id])

    if @layout_cell.update_attributes(params[:layout_cell])
      redirect_to admin_layout_cells_url
    else
      @layout_cell = LayoutCell.find(:all)
      render :action => "index"
    end
  end

  def destroy
    LayoutCell.find(params[:id]).destroy
    redirect_to admin_layout_cells_url
  end

end
