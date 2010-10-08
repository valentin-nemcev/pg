# -*- coding: utf-8 -*-
class SiteController < ApplicationController
  include SimpleCaptcha::ControllerHelpers
  layout "site"
  
  def main
     # @articles = Article.paginate(:page => params[:page], :order => 'publication_date DESC', :conditions => ['publicated = ? AND publication_date <= ?', true, Time.now] )
  end
  
  def tag
    if tag = Tag.find_by_uri(params[:tag_uri])
      @articles = tag.articles.publicated.ordered.paginate(:page => params[:page], :per_page => 30)
    else
      not_found
    end
  end
  
  
  
  def article
    @article = Article.publicated.find_by_uri params[:article_uri]
    return not_found unless @article
    @comments = @article.comments.paginate(:page => params[:page], :per_page => 25)
  end
  
  def legacy_uri
    if @article = Article.publicated.find_by_legacy_uri(params[:legacy_uri].join('/')) 
      redirect_to article_url(@article.uri), :status => :moved_permanently
    else
      not_found
    end
  end

  def post_comment
    @article = Article.publicated.find_by_uri params[:article_uri]
    return not_found unless @article
    return redirect_to article_url(@article.uri, :anchor => "comments") unless @article.can_be_commented?
    @comment = @article.comments.build params[:comment]
    if simple_captcha_valid? && @comment.save
      redirect_to article_url(@article.uri, :anchor => "comments")
    else
      @comment.errors.add_to_base "Ошибка в капче" unless simple_captcha_valid?
      article
      render :article
    end  
  end

  def feed
    if params[:yandex]
      send_file 'yandex_feed', :type => 'application/xml; charset=utf-8'
    else
      @articles = Article.publicated.ordered.limited(25).all :conditions => ['publication_date > ?', 8.day.ago] 
      render :layout => false
    end
  end

  def search
  end

  def not_found
    render 'not_found', :status  => :not_found
  end
  
  def all_tags
    
  end
end
