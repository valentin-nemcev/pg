class Admin::CategoriesController < AdminController

  def index
    @categories = Category.find(:all, :conditions => {:archived => false})
    @categories_archived = Category.find(:all, :conditions => {:archived => true})
    render :action => "index"
  end

  def new
    return create if request.post?
    @category = Category.new
    render :action => "form.haml" #Заменить на что-нибудь более логичное
  end

  def edit
    @category = Category.find(params[:id])
    render :action => "form.haml"
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:notice] = 'Рубрика сохранена'
      redirect_to admin_categories_url
    else
      render :action => "form.haml" 
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      flash[:notice] = 'Рубрика сохранена'
      redirect_to admin_categories_url
    else
      render :action => "form.haml" 
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if params[:with_articles]
      @category.destroy_with_articles
    else
      @category.destroy
    end
    flash[:notice] = 'Рубрика удалена'
    redirect_to admin_categories_url
  end
end
