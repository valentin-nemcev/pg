xml.instruct! :xml, :version => "1.0" 
xml.instruct! 'xml-stylesheet', :type => "text/css", :href => File.join(root_url, stylesheet_path('rss'))

xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Полит-грамота"
    xml.description "Полит-грамота – молодежный медиа проект"
    xml.link root_url
    
    for article in @articles
      xml.item do
        xml.title article.title_html
        # xml.description do
        #   xml.style <<-CSS
        #       img.left {
        #         float: left;
        #         padding-right: 4px; }
        #       
        #       img.right {
        #         float: right;
        #         padding-left: 4px; }
        #     CSS
        #   xml.h2 'aaaa'#article.subtitle_html
        #   xml.div article.lead_html
        # end
        xml.description render 'article_rss_description', :article => article
        xml.pubDate article.publication_date.to_s(:rfc822)
        xml.link article_url(article.uri)
        xml.guid article.uri
      end
    end
  end
end