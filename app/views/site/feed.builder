# -*- coding: utf-8 -*-
xml.instruct! :xml, :version => "1.0", :encoding=>"UTF-8"

xml_attrs = {:version => "2.0" }
xml_attrs[:"xmlns:yandex"] = "http://news.yandex.ru" if params[:yandex]

xml.rss xml_attrs do
  xml.channel do
    xml.title "Полит-грамота"
    xml.description "Полит-грамота – молодежный медиа проект"
    xml.link root_url
    
    xml.image do
        xml.url root_url + "images/logo_v4_small.gif"
        xml.title  "Полит-грамота – молодежный медиа проект"
        xml.link root_url
    end     
    
    for article in @articles
      xml.item do
        xml.title article.title_html
        xml.description render 'article_rss_description', :article => article, :yandex => params[:yandex]
        xml.pubDate article.publication_date.to_s(:rfc822)
        xml.link article_url(article.uri)
        xml.guid article.uri
        if params[:yandex]
          require 'hpricot'
          doc = Hpricot(article.text_html)
          doc.search('p.signature, img').remove
          # xml.yandex :"full-text", article.text_html.gsub(/<img[^>]+\>/, '')
          xml.yandex :"full-text", doc.to_html
        end
      end
    end
  end
end
