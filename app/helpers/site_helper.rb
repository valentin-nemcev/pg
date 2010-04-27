module SiteHelper
  def page_title(title)
    content_for :title, title + " &mdash; "
  end
  
  
  def tag_cloud(font_size_range)
    tags = Tag.all(:select => 'count(articles.id) as articles_cnt, tags.*', 
      :joins => :articles, 
      :having => 'articles_cnt > 3', 
      :group => 'tags.id', 
      :order => 'RAND()' )

    compare_by_articles_count = lambda { |a, b| a.articles_cnt.to_i <=> b.articles_cnt.to_i }
    maxlog = Math.log(tags.max(&compare_by_articles_count).articles_cnt)
    minlog = Math.log(tags.min(&compare_by_articles_count).articles_cnt)
    rangelog = maxlog - minlog;
    rangelog = 1 if maxlog==minlog


    tags.each { |t|
      font_size = font_size_range.first + (font_size_range.last - font_size_range.first) * (Math.log(t.articles_cnt) - minlog) / rangelog 
      yield t, sprintf("%.2f", font_size)
    }
  end
  module_function :tag_cloud
  
end