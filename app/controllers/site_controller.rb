class SiteController < ApplicationController
  layout "site"
  
  def main
     # @articles = Article.paginate(:page => params[:page], :order => 'publication_date DESC', :conditions => ['publicated = ? AND publication_date <= ?', true, Time.now] )
  end
  
  def category
    link = Link.find_by_text(params[:category_link])
    if link.nil? or link.linked.nil? 
      render :text => "404 Not Found", :status => 404 
    else
      category = link.linked
    end
    @articles = Article.paginate(
      :page => params[:page],
      :conditions => [ 'category_id = ? AND publicated = ? AND publication_date <= ?', category, true, Time.now ],
      :order => 'publication_date DESC'
       )
  end
  
  def article
    link = Link.find_by_text(params[:article_link])
    if link.nil? or link.linked.nil? 
      render :text => "404 Not Found", :status => 404 
    else
      @article = link.linked
    end
  end
  
  def image
    @image = Image.find_by_link(params[:image_link])
    render :text => @image.image_data.to_blob, :content_type => 'image/jpeg', :status => '200'
    
  end
  
end
