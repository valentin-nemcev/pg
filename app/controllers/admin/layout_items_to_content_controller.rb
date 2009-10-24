class Admin::LayoutItemsToContentController < AdminController
  def move
    LayoutItemsToContent.find(params[:id]).move(params[:direction].to_sym)
    redirect_to admin_layout_items_url
  end
  
  def new
    layout_item = LayoutItem.find(params[:layout_item_id])
    render :partial => "layout_item_content_new", :locals => {:layout_item => layout_item}
  end

  def destroy
    LayoutItemsToContent.find(params[:id]).destroy
    redirect_to admin_layout_items_url
  end

end
