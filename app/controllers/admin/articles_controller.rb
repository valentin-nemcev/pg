class Admin::ArticlesController < AdminController
  
  def index
    @articles = Article.find(:all)
    render :action => "index"
  end

  def new
    @revision = Revision.new
    @form_method = :put
    @form_url = new_admin_article_path()
    render  "admin/revisions/edit"
  end

  def edit
    redirect_to new_admin_article_revision_path(params[:id])
  end

  def create
    @revision = Revision.new(params[:revision])
    
    if @revision.save
      @revision.create_article
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "revisions/edit"
    end

  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    flash[:notice] = 'Статья удалена'
    redirect_to admin_articles_path
  end
end
