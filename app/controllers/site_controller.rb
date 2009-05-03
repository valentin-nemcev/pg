class SiteController < ApplicationController
  layout "site"
  
  before_filter :get_categories_for_menu
  
  
  def main
    @articles = Article.find(:all)
  end
  
  def category
    @articles = Article.find(:all, :include => { :current_revision => :category }, :conditions => [ 'categories.link = ?', params[:category_link] ] )
  end
  
  def article
    #@article = Article.find(:first, :include => :category, 
    #  :conditions => [ 'articles.link = ? AND categories.link = ?', params[:article_link], params[:category_link] ] )
    link = Link.find_by_text(params[:article_link])
    if link.nil? or link.linked.nil? 
      render :text => "404 Not Found", :status => 404 
    else
      @article = link.linked
    end
  end
  
  private
    def get_categories_for_menu
      @categories = Category.all
      
    end
end
