#encoding: utf-8
class Admin::ArticlesController < Admin::ResourceController
  has_scope :with_tags, :with_text
  
  def search
    @articles = Article.search(params[:with_text], :page => params[:page])
    render 'index'
  end
  
  def tag
    articles = apply_scopes(Article).all
    tags = Tag.find_or_create_by_tag_string(params[:tags])
    logger.info tags
    articles.each{|a| a.tags |= tags }
    tags.map(&:update_count)
    current_scopes[:search] = params[:search]
    redirect_to admin_articles_url(current_scopes)
  end
  
  protected
  
    def collection
      @articles ||= end_of_association_chain.paginate(:page => params[:page])
      
      # return if @articles
      #       @articles = end_of_association_chain
      #       @articles = unless params[:search].blank?
      #         @articles.scoped_search.search params[:search]
      #       else
      #         @articles.ordered.paginate(:page => params[:page])
      #       end
      # @articles = @articles .paginate(:page => params[:page])
    end
  
end
