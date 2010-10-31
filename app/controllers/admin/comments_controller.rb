class Admin::CommentsController < Admin::ResourceController


  protected
  
    def collection
      @images ||= end_of_association_chain.ordered('publication_date DESC').paginate(:page => params[:page])
    end
end
