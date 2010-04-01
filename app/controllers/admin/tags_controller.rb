class Admin::TagsController < InheritedResources::Base
  before_filter :login_required
  layout "admin"
  
  def update
    update! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
end
