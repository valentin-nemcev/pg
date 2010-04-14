module Admin::ImagesHelper
  def article_list(image)
    image.articles.map do |article|
      link_to article.title, edit_admin_article_path(article.id)
    end.join(', ')
  end
end
