module Admin::ArticlesHelper
  def publication_status(article)
    if article.is_publicated and article.publication_date <= Time.now
      "Опубликовано"
    elsif article.is_publicated and article.publication_date > Time.now
      "Ожидает публикации"
    elsif not article.is_publicated and article.publication_date <= Time.now
      "Не опубликовано"
    elsif not article.is_publicated and article.publication_date > Time.now
      "Готовиться к публикации"
    end
  end
  
  def tag_links(article)
    article.tags.map do |t|
      link_to_unless_current t.name, tag_path(t.uri)
    end.join(', ')
  end
end