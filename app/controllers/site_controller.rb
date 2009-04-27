class SiteController < ApplicationController
  layout "site"
  
  before_filter :get_categories_for_menu
  
  
  def main
  end
  
  def category
    @articles = Article.find(:all, :include => { :current_revision => :category }, :conditions => [ 'categories.link = ?', params[:category_link] ] )
  end
  
  def article
    @article = Article.find(:first, :include => :category, 
      :conditions => [ 'articles.link = ? AND categories.link = ?', params[:article_link], params[:category_link] ] )
  end
  
  private
    def get_categories_for_menu
      @categories = Category.all
      
    end
end
