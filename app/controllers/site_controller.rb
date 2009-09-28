class SiteController < ApplicationController
  layout "site"
  
  before_filter :get_categories_for_menu
  
  
  def main
     @articles = Article.paginate(:page => params[:page], :order => 'publication_date DESC', :limit=>10 )
  end
  
  def category
    @articles = Article.find(
      :all,
      :include => :category,
      :conditions => [ 'categories.link = ?', params[:category_link] ],
      :order => 'publication_date DESC'
       )
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
  
  def image
    @image = Image.find_by_link(params[:image_link])
    # send_data @image.image_data.to_blob, 
    #               :type => 'image/jpeg', :disposition => 'inline',
    #               :status => '200'
    render :text => @image.image_data.to_blob, :content_type => 'image/jpeg', :status => '200'
    
  end
  
  private
    def get_categories_for_menu
      @categories = Category.all
      
    end
end
