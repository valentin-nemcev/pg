class Admin::CategoriesController < AdminController
  
  
  def index
    @categories = Category.find(:all)
    render :action => "index"
  end

  def new
    @category = Category.new
    render :action => "edit" #Заменить на что-нибудь более логичное
  end

  def edit
    @category = Category.find(params[:id])
    render :action => "edit"
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to admin_categories_url
    else
      render :action => "edit" 
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to admin_categories_url
    else
      render :action => "edit" 
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    redirect_to admin_categories_url
  end
end
