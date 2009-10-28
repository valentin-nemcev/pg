class Admin::ImagesController < AdminController
  
  def show
    @image = Image.find(params[:id])
    send_data @image.image_data.to_blob, :disposition => 'inline'
  end
  
  def full
    @image = Image.find(params[:id])
    send_data @image.full_data.to_blob, :disposition => 'inline'
  end
  
  def for_edit
    @image = Image.find(params[:id])
    send_data @image.for_edit_data.to_blob, :disposition => 'inline'
  end
  
  def thumb
    @image = Image.find(params[:id])
    send_data @image.thumb_data.to_blob, 
      :disposition => 'inline'
  end
  
  def index
    if params[:article_id] 
      @images = Article.find(params[:article_id]).images 
    else
      @images = Image.paginate(:page => params[:page], :per_page => 30)
    end
      
    if (request.xhr?)
      render :action => "index_for_adding.js", :layout => false
    else
      render :action => "index"
    end
  end

  def new
    return create if request.post?
    @image = Image.new
    if (request.xhr?)
       render :action => "upload.js", :layout => false
     else
       render :action => "edit" 
     end
  end
  
  def edit
    @image = Image.find(params[:id])
    render :action => "edit"
  end
  
  def crop_form
    @image = Image.find(params[:id])
    if request.xhr?
      render :action => "crop.js", :layout => false
    else
      render :action => "crop"
    end
  end
  
  def create
    @image = Image.new(params[:image])
    if @image.save
      if (params[:xhr])
        response.headers['Content-type'] = 'text/html; charset=utf-8' # Что бы ответ не оборачивался в <pre> в iframe-е
        render :action => "refresh_image.js", :layout => 'textarea'
      else
        flash[:notice] = 'Изображение сохранено'
        redirect_to admin_images_url
      end
    else
      if (params[:xhr])
        response.headers['Content-type'] = 'text/html; charset=utf-8' # Что бы ответ не оборачивался в <pre> в iframe-е
        render :action => "upload.js", :layout => 'textarea'
      else
        render :action => "edit" 
      end
    end
  end

  def update
    @image = Image.find(params[:id])

    if @image.update_attributes(params[:image])
      if request.xhr?
        render :action => "refresh_image.js", :layout => false
      else
        flash[:notice] = 'Изображение сохранено'
        redirect_to admin_images_url
      end
    else
      if request.xhr?
         render :action => "refresh_image.js", :layout => false
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
