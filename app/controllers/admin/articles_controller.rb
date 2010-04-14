#encoding: utf-8
class Admin::ArticlesController < Admin::ResourceController
  has_scope :with_tags
  
  
  protected
  
    def collection
      @articles ||= end_of_association_chain.ordered.paginate(:page => params[:page])
    end
  
end
