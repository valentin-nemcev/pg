class Admin::RevisionsController < AdminController
  
  def index
    @revisions = Revision.all(:conditions => ["article_id = ?", params[:article_id]])
    render :action => "index"
  end

  def new
    if params[:article_id].nil?
      @revision = Revision.new
    else
      @revision = Article.find(params[:article_id]).current_revision.clone
      @revision.article_id = params[:article_id] 
    end
    @revision.article.links.build
    render :action => "edit"
  end

  def create
    @revision = Revision.new(params[:revision])
    @revision.editor = current_user
    @revision.build_article if @revision.article.nil?
    if @revision.save
      @revision.article.current_revision = @revision
      @revision.article.save
      @revision.save(false)
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end

  end
  
  def edit
    @revision = Revision.find(params[:id])
    render :action => "edit"
  end
  
  def update
    @revision = Revision.find(params[:id])

    if @revision.update_attributes(params[:revision])
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end

  end

  def destroy
    @revision = Revision.find(params[:id])
    @revision.destroy
    
    flash[:notice] = 'Статья удалена'
    redirect_to admin_articles_path
  end
end
