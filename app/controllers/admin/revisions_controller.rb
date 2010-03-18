#encoding: utf-8
class Admin::RevisionsController < AdminController
  
  def index
    @revisions = Revision.all(:conditions => ["article_id = ?", params[:article_id]])
    render :action => "index"
  end

  def destroy
    @revision = Revision.find(params[:id])
    @revision.destroy
    
    flash[:notice] = 'Статья удалена'
    redirect_to admin_articles_path
  end
end
