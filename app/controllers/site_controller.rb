class SiteController < ApplicationController
  layout "site"
  def main
    @categories = Category.all
  end
  
  def article
    @article = Article.find(params[:article])
  end
end
