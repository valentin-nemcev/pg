class Admin::LayoutItemsController < AdminController
  def index
    @layout_item = LayoutItem.new
    @layout_items = LayoutItem.find(:all)
    render :action => "index"
  end

  def create
    @layout_item = LayoutItem.new(params[:layout_item])

    if @layout_item.save
      redirect_to admin_layout_items_url
    else
      @layout_items = LayoutItem.find(:all)
      render :action => "index"
    end
  end

  def update
    @layout_item = LayoutItem.find(params[:id])

    if @layout_item.update_attributes(params[:layout_item])
      redirect_to admin_layout_items_url
    else
      @layout_items = LayoutItem.find(:all)
      render :action => "index"
    end
  end

  def destroy
    LayoutItem.find(params[:id]).destroy
    redirect_to admin_layout_items_url
  end

end
