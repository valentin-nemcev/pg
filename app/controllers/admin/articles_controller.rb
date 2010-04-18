#encoding: utf-8
class Admin::ArticlesController < Admin::ResourceController
  has_scope :with_tags #, :with_text
  
  def search
    @articles = Article.search(params[:with_text], :page => params[:page])
    render 'index'
  end
  
  protected
  
    def collection
      @articles ||= end_of_association_chain.ordered.paginate(:page => params[:page])
    end
  
end
