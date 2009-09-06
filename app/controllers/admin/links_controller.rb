class Admin::LinksController < AdminController
  
  def index
    if params[:article_id].nil? 
      @links = Link.find(:all)
    else
      @links = Link.find(:all, :conditions => ["linked_id = ? and linked_type = 'Article'", params[:article_id]])
      @canonical_link = Article.find(params[:article_id]).canonical_link
    end
    render :action => "index"
  end

  def destroy
    link = Link.find(params[:id])    
    link.destroy
    
    redirect_to admin_links_path
  end
end
