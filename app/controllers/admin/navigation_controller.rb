class Admin::NavigationController < Admin::ResourceController
  def update
    update! do |success, failure|
      success.html { redirect_to admin_navigation_index_url }
    end
  end

end
