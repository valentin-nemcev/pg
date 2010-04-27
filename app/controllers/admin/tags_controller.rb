class Admin::TagsController < Admin::ResourceController
  
  def merge
    tag = resource
    merge_with = Tag.find(params[:merge_with])
    tag.articles.each { |article| article.tags << [merge_with] until article.tags.exists? merge_with.id }
    tag.destroy
    
  end
  
  protected
  
    def collection
      @images ||= end_of_association_chain.ordered_by_articles
    end
end
