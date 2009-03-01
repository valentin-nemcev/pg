class Admin::ArticlesController < ApplicationController
  layout "admin"
  

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
      flash[:notice] = 'Article was successfully created.'
      redirect_to admin_articles_path
    else
      render :action => "new"
    end

  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated.'
      redirect_to admin_articles_path
    else
      render :action => "edit"
    end

  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to admin_articles_path
  end
end
