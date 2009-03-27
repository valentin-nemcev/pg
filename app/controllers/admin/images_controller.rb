class Admin::ImagesController < AdminController
  
  def show
    @image = Image.find(params[:id])
    send_data @image.image_blob, :disposition => 'inline'
  end
  
  def thumb
    @image = Image.find(params[:id])
    send_data @image.thumb_blob, :disposition => 'inline'
  end
  
  def index
    @images = Image.find(:all)
    render :action => "index"
  end

  def new
    @image = Image.new
    render :action => "edit" #Заменить на что-нибудь более логичное
  end

  def edit
    @image = Image.find(params[:id])
    render :action => "edit"
  end

  def create
    @image = Image.new(params[:image])

    if @image.save
      flash[:notice] = 'Изображение сохранено'
      redirect_to admin_images_url
    else
      render :action => "edit" 
    end
  end

  def update
    @image = Image.find(params[:id])

    if @image.update_attributes(params[:image])
      flash[:notice] = 'Изображение сохранено'
      redirect_to admin_images_url
    else
      render :action => "edit" 
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:notice] = 'Изображение удалено'
    redirect_to admin_images_url
  end
end
