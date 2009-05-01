class Admin::LinksController < AdminController
  
  def index
    @links = Link.find(:all)
    render :action => "index"
  end

  def destroy
    link = Link.find(params[:id])    
    link.destroy
    
    redirect_to admin_links_path
  end
end
