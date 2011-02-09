# -*- coding: utf-8 -*-
module SiteHelper
  def page_title(title)
    content_for :title, title + " &mdash; "
  end
  
  
  def tag_cloud(font_size_range)
    tags = Tag.all(:select => 'count(articles.id) as articles_cnt, tags.*', 
      :joins => :articles, 
      # :having => 'articles_cnt > 1', 
      :group => 'tags.id', 
      :order => 'name' )

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

  def manual_tag_cloud
    tags = [
            # {:name => 'Псков'           , :style => 'small'  , :pos => [20,  9]},
            # {:name => 'Новгород'        , :style => 'small'  , :pos => [60, 15]},
            {:name => 'Петербург'       , :style => 'small'  , :pos => [21, 52]},
            {:name => 'Карелия'         , :style => 'small'  , :pos => [78, 57]},
            {:name => 'Архангельск'     , :style => 'small'  , :pos => [55, 80]},
            {:name => 'Поле зрения'     , :style => 'medium' , :pos => [72,  4]},
            {:name => 'Со-вещание'      , :style => 'medium' , :pos => [35,  9]},
            # {:name => 'В порядке бреда' , :style => 'medium' , :pos => [53, 35]},
            # {:name => 'Портрет'         , :style => 'medium' , :pos => [ 3, 49]},
            # {:name => 'Слово редактору' , :style => 'medium' , :pos => [ 6, 71]},
            # {:name => 'Дайджест'        , :style => 'medium' , :pos => [35, 77]},
            {:name => 'Репортаж'        , :style => 'big'    , :pos => [ 9, 23]},
            {:name => 'Дебаты'          , :style => 'big'    , :pos => [59, 31]},
            {:name => 'Субъектив'       , :style => 'big'    , :pos => [39, 53]},
            {:name => 'Интервью'        , :style => 'big'    , :pos => [5, 70]}
           ]
    tags.each do |tag_desc|
      tag = Tag.find_by_name(tag_desc[:name]) or next
      yield tag, tag_desc[:style], tag_desc[:pos][0], tag_desc[:pos][1]
    end
  end

  def tag_line
    tags = ['ЕР', 'КПРФ', 'ЛДПР', 'Наши', 'Оборона', 'Правое дело',  'РНДС', 'РСДСМ', 'СР', 'ФСМ', 'Яблоко']
    
    tags.each do |tag_desc|
      tag = Tag.find_by_name(tag_desc) or next
      yield tag
    end

  end
end

