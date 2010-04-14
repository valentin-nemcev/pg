class Admin::TagsController < Admin::ResourceController
  protected
  
    def collection
      @images ||= end_of_association_chain.ordered
    end
end
