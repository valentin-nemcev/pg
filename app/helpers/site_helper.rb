module SiteHelper
  def page_title(title)
    content_for :title, title + " &mdash; "
  end
  
  def tag_cloud(font_size_range)
    tags = Tag.all(:select => 'count(articles.id) as articles_count, tags.*', 
      :joins => :articles, 
      :having => 'count(articles.id) > 1', 
      :group => 'tags.id', 
      :order => 'name' )

    compare_by_articles_count = lambda { |a, b| a.articles_count <=> b.articles_count }
    maxlog = Math.log(tags.max(&compare_by_articles_count).articles_count)
    minlog = Math.log(tags.min(&compare_by_articles_count).articles_count)
    rangelog = maxlog - minlog;
    rangelog = 1 if maxlog==minlog


    tags.each { |t|
      font_size = font_size_range.first + (font_size_range.last - font_size_range.first) * (Math.log(t.articles_count.to_i) - minlog) / rangelog 
      yield t, sprintf("%.2f", font_size)
    }
  end
  
end