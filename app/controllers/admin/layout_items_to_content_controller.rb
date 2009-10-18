class Admin::LayoutItemsToContentController < AdminController
  def move
    LayoutItemsToContent.find(params[:id]).move(params[:direction].to_sym)
    redirect_to admin_layout_items_url
  end

  def destroy
    LayoutItemsToContent.find(params[:id]).destroy
    redirect_to admin_layout_items_url
  end

end
