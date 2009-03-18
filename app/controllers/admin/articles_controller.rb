class Admin::ArticlesController < AdminController
  

  def index
    @articles = Article.find(:all)
    render :action => "index"
  end

  def new
    @article = Article.new
    @form_method = :put
    @form_url = new_admin_article_path()
    render :action => "edit"
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end

  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end

  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    flash[:notice] = 'Статья удалена'
    redirect_to admin_articles_path
  end
end
