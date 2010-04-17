class Admin::ResourceController < AdminController
  
  
  inherit_resources
  
  def update
    update! do |success, failure|
      success.html { redirect_to edit_resource_url }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to edit_resource_url }
    end
  end
  

end
