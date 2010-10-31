#encoding: utf-8
class Admin::ArticlesController < Admin::ResourceController
  # has_scope :with_tags, :type => :array
  # has_scope :with_text
  
  
  def tag
    articles = apply_scopes(Article).all
    tags_to_add = Tag.find_or_create_by_tag_list(params[:add_tags])
    tags_to_remove = Tag.find_or_create_by_tag_list(params[:remove_tags])
    articles.each{|a| a.tags |= tags_to_add; a.tags -= tags_to_remove }
    redirect_to admin_articles_url(current_scopes)
  end
  
  protected
  
    def collection
      @articles ||= if current_scopes[:with_text]
        end_of_association_chain.paginate(:page => params[:page])
      else
        end_of_association_chain.ordered.paginate(:page => params[:page]) # if end_of_association_chain.present?
      end
    end
  
end
