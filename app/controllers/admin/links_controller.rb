class Admin::LinksController < AdminController
  
  def index
    @links = Link.find(:all)
    render :action => "index"
  end


end
