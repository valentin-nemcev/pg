#encoding: utf-8
class Admin::QuotesController < AdminController
  def index
    @quotes = Quote.find(:all)
    render :action=> 'index'
  end

  def new
    return create if request.post?
    @quote = Quote.new
    render :action => "edit"
  end

  def edit
    @quote = Quote.find(params[:id])
    render :action => "edit"
  end

  def create
    @quote = Quote.new(params[:quote])
    if @quote.save
      flash[:notice] = 'Цитата сохранена'
      redirect_to admin_quotes_path
    else
      render :action => "edit"
    end
  end

  def update
    @quote = Quote.find(params[:id])
    if @quote.update_attributes(params[:quote])
      flash[:notice] = 'Цитата сохранена'
      redirect_to admin_quotes_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy
    flash[:notice] = 'Цитата удалена'
    redirect_to admin_quotes_path
  end

end
