#encoding: utf-8
class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all :order => 'archived ASC, hidden ASC, position ASC'
      
    render :action => "index"
  end

  def new
    return create if request.post?
    @category = Category.new
    render :action => "form.haml" 
  end

  def edit
    @category = Category.find(params[:id])
    render :action => "form.haml"
  end

  def create
    @category = Category.new(params[:category])

    if @category.save 
      flash[:notice] = 'Рубрика сохранена' # TODO вынести в locale
      redirect_to admin_categories_url
    else
      render :action => "form.haml" 
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      flash[:notice] = 'Рубрика сохранена' # TODO вынести в locale
      redirect_to admin_categories_url
    else
      render :action => "form.haml" 
    end
  end

  def move
    Category.find(params[:id]).move(params[:direction].to_sym)
    redirect_to admin_categories_url
  end

  def destroy
    @category = Category.find(params[:id])
    if params[:with_articles]
      @category.destroy_with_articles
    else
      @category.destroy
    end
    flash[:notice] = 'Рубрика удалена' # TODO вынести в locale
    redirect_to admin_categories_url
  end
end
