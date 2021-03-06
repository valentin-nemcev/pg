# -*- coding: utf-8 -*-
class SiteController < ApplicationController
  include SimpleCaptcha::ControllerValidation

  layout "site"
  before_filter :navigation


  def main
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
    @articles = Article.publicated.ordered.limited(12)
    @articles = @articles.for_yandex if params[:yandex]
    render :layout => false
  end

  def search
  end

  def not_found
    render 'not_found', :status  => :not_found
  end

  def all_tags

  end

  protected

    def navigation
      @tag_nav = [
        [:big,    Navigation.find_by_name('tag_nav_big').tags],
        [:medium, Navigation.find_by_name('tag_nav_medium').tags],
        [:small,  Navigation.find_by_name('tag_nav_small').tags],
      ]
      @tag_line = Navigation.find_by_name('tag_line').tags
    end
end
