class SiteController < ApplicationController
  layout "site"
  
  def main
     # @articles = Article.paginate(:page => params[:page], :order => 'publication_date DESC', :conditions => ['publicated = ? AND publication_date <= ?', true, Time.now] )
  end
  
  def tag
    @articles = Tag.find_by_uri(params[:tag_uri]).articles.ordered
  end
  
  def archive
    @categories = Category.archived
  end
  
  def article
    @article = Article.first :conditions => {:uri => params[:article_uri]}
  end
  
  def image
    @image = Image.find_by_link(params[:image_link])
    render :text => @image.image_data.to_blob, :content_type => 'image/jpeg', :status => '200'
    
  end
  
end
