class Admin::ImagesController < AdminController
  
  def show
    @image = Image.find(params[:id])
    send_data @image.image_data.to_blob, :disposition => 'inline'
  end
  
  def thumb
    @image = Image.find(params[:id])
    send_data @image.thumb_data.to_blob, 
      :type => @image.thumb_data.mime_type, 
      :filename => @image.link+@image.thumb_data.format, 
      :disposition => 'inline'
  end
  
  def index
    if params[:article_id] 
      @images = Article.find(params[:article_id]).images 
    else
      @images = Image.paginate(:page => params[:page], :per_page => 30)
    end
      
    if (request.xhr?)
      render :partial => @images
    else
      render :action => "index"
    end
  end

  def new
    return create if request.post?
    @image = Image.new
    if (request.xhr?)
       render :partial => "edit"
     else
       render :action => "edit" 
     end
  end

  def edit
    @image = Image.find(params[:id])
    render :action => "edit"
  end

  def create
    @image = Image.new(params[:image])
    
        
    
    logger.info 'params ' + params.inspect
    
    if @image.save
      flash[:notice] = 'Изображение сохранено'
      redirect_to admin_images_url
    else
      if (params[:xhr])
         render :partial => "edit"
       else
         render :action => "edit" 
       end
    end
  end

  def update
    @image = Image.find(params[:id])

    if @image.update_attributes(params[:image])
      flash[:notice] = 'Изображение сохранено'
      redirect_to admin_images_url
    else
      if (params[:xhr])
         render :partial => "edit"
       else
         render :action => "edit" 
       end
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:notice] = 'Изображение удалено'
    redirect_to admin_images_url
  end
end
