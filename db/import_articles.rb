#!/usr/bin/env /Users/valentine/Work/Polit-gramota/pg/script/runner
require 'pp'

class DBConn < ActiveRecord::Base
	establish_connection(
				  :adapter => 'mysql', 
					:host=> 'localhost', 
					:username => 'root', 
					:password => '', 
					:database => 'old',
					:encoding => 'utf8'
			)
end			



def html2textile(text)
  require 'htmlentities'
  coder = HTMLEntities.new
  text.gsub!('&shy;', '') # Выкинули мягкие переносы
  text.gsub!('­', '') # Выкинули мягкие переносы
  
  # print text
  text.gsub!(/\s+/, ' ')
  text.gsub!(/<br[^>]*>/, "\n") # ...и переносы строк
  
  text.gsub!(/<p class="(\w+)">/) do
    style=$~[1].gsub('script','signature'); 
    return "" if style=="MsoNormal"
    "p(#{style}). "
  end
  text.gsub!(/<p>/,"")
  text.gsub!(/<\/p>/,"\n\n")
  text.gsub!(/<h5>/,"h3. ")
  text.gsub!(/<\/h5>/,"\n\n")
  text.gsub!(/<ul>/,"")
  text.gsub!(/<\/ul>/,"")
  text.gsub!(/<li>/,"p(list). ")
  text.gsub!(/<\/li>/,"\n\n")
  text.gsub!(/<strong>\s*/,"*")
  text.gsub!(/\s*<\/strong>/,"*")
  text.gsub!(/<em>\s*/,"_")
  text.gsub!(/\s*<\/em>/,"_")
  
  images = []
  text.gsub!(/<img src="http:\/\/polit-gramota.ru\/images\/([^"]*)"(?: style="float: (\w+);[^"]*")?[^>]*>/) do
    img = $~[1]
    images << img
    style = $~[2].nil? ? "" : "(#{$~[2]})"
    "!#{style}/img/#{img}!"
  end
  
  text.gsub!(/<a href="(.+?)">(.+?)<\/a>/) do
    link = $~[1]; text = $~[2] 
    link.gsub!('http://polit-gramota.ru','') 
    text = "\"#{text}\"" if not text.match(/^!(.+?)!$/) # Это не изображение, текст ссылки в кавычки
    "#{text}:#{link}"
  end
  # match = text.scan(/<[^>]*>/)
  # if not match.empty?
    # puts "#{article['title']} #{article['date']}"
    # pp match
  # end 
  # text.gsub!(/<\/?[^>]*>/, '') # Выкинули теги
  text = coder.decode(text) # Заменили html entities
  text.gsub!(/^ +/, '') # Выкинули пробел в начале строки
  text.gsub!(/^ +/, '') # Выкинули nbsp пробел в начале строки
  text.gsub!(/\n{3,}/, "\n\n");
  return [text, images]
end
cb = User.find_by_name('ConvertBot')    
deleted_revs = Revision.destroy_all(:editor_id => cb)
puts "Deleted #{deleted_revs.length} earlier converted revisions"
DBConn.connection.select_all('SELECT * FROM articles  ').each do |a|
  lead, lead_images = html2textile(a['lead'])
  text, text_images = html2textile(a['text'])
  # pp Time.at(a['date'].to_i)
  
  # pp lead_images.to_a | text_images.to_a
  art = Article.new(
    :title => a['title'],
    :subtitle => a['subtitle'],
    :publication_date => Time.at(a['date'].to_i),
    :text => text,
    :lead => lead,
    :editor => cb
  )
  art.save
    art.links.create(:text => a['link'], :editor => cb) 
    #   
  #   p art
end
