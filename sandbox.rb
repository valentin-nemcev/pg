#!/usr/bin/env script/runner

 # p Article.find(639).convert_legacy_fields.save!
 
# p Article.find(91).text

# p Russian.translit('Оппозиция: издержки роста или карлик навсегда?').parameterize
# p 'a' * 120


# ids = Article.search_for_ids('сми')
# order = "field(id, #{ids.join(',')})"
# puts Article.all(:conditions => {:id => ids}, :order => order).map(&:id)





SiteHelper.tag_cloud 0.5..1.5 do |tag, size| 
  p "#{tag.uri} - #{size}"
end