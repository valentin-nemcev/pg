class Admin::LinksController < AdminController
   parent_resources :category, :article
  
  def index
    @parent = parent_object
    @links = @parent.links
    render :action => "index"
  end
  
  def new
    return create if request.post?
    @parent = parent_object
    @link = @parent.links.build()
    render :action => "form.haml" 
  end


  def create
    @parent = parent_object
    @link = @parent.links.build(params[:link])

    if @link.save
      flash[:notice] = 'Ссылка добавлена'
      redirect_to polymorphic_path([:admin, @parent, :links])
    else
      render :action => "form.haml" 
    end
  end
  
  def destroy
    link = Link.find(params[:id])    
    link.destroy
    
    redirect_to polymorphic_path([:admin, parent_object, :links])
  end
  
  def make_canonical
    link = get_link
    parent = parent_object
    parent.canonical_link = link
    parent.save(false)
    redirect_to polymorphic_path([:admin, parent, :links])
  end
  
  protected
    def get_link
      Link.find(:first, :conditions => {:id => params[:id], :linked_type => parent_type.to_s.classify, :linked_id => parent_id(parent_type)})
    end
end
