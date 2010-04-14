#encoding: utf-8
class Admin::ImagesController < Admin::ResourceController
  has_scope :ordered_by_articles
  
  
  protected
  
    def collection
      @images ||= end_of_association_chain.ordered.paginate(:page => params[:page])
    end
end
