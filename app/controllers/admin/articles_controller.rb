class Admin::ArticlesController < AdminController
  
  def index
    @articles = Article.find(:all)
    render :action => "index"
  end

  def new
    @article = Article.new
    render :action => "edit"
  end

  def edit
    @article = Article.find(params[:id])
    render :action => "edit"
  end

  def create
    @article = Article.new(params[:article])
    @article.editor = current_user
    if @article.save
      flash[:notice] = 'Статья сохранена'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end
  end
  
  def update
    @article = Article.find(params[:id])
    @article.editor = current_user
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
