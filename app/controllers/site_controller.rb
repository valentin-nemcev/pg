class SiteController < ApplicationController
  layout "site"
  
  def main
     # @articles = Article.paginate(:page => params[:page], :order => 'publication_date DESC', :conditions => ['publicated = ? AND publication_date <= ?', true, Time.now] )
  end
  
  def tag
    if tag = Tag.find_by_uri(params[:tag_uri])
      @articles = tag.articles.publicated.ordered.paginate(:page => params[:page], :per_page => 30)
    else
      not_found
    end
  end
  
  def article
    @article = Article.find_by_uri params[:article_uri]
    not_found unless @article
  end
  
  def legacy_uri
    if @article = Article.find_by_legacy_uri(params[:legacy_uri].join('/')) 
      redirect_to article_url(@article.uri), :status => :moved_permanently
    else
      not_found
    end
  end

  def not_found
    render 'not_found', :status  => :not_found
  end
  
end
