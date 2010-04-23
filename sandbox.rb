#!/usr/bin/env script/runner

 # p Article.find(639).convert_legacy_fields.save!
 
# p Article.find(91).text

# p Russian.translit('Оппозиция: издержки роста или карлик навсегда?').parameterize
# p 'a' * 120


# ids = Article.search_for_ids('сми')
# order = "field(id, #{ids.join(',')})"
# puts Article.all(:conditions => {:id => ids}, :order => order).map(&:id)

def tag_cloud(max_size)
  tags = Tag.all(:select => 'count(articles.id) as articles_count, articles.*', :joins => :articles, :having => 'count(articles.id) > 0', :group => 'tags.id', :order => 'count(articles.id) desc' )
  
  maxlog = Math.log(tags.first.articles_count)
  minlog = Math.log(tags.last.articles_count)
  rangelog = maxlog - minlog;
  rangelog = 1 if maxlog==minlog
  
  
  tags.each { |t|
    font_size = 1 + (max_size - 1) * (Math.log(t.articles_count.to_i) - minlog) / rangelog 
    yield t, font_size
  }
end



tag_cloud tags, 5 do |tag, size| 
  p tag, size
end