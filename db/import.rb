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
  text.gsub!(/\*\*/,"")
  text.gsub!(/\_\_/,"")
  
  images = []
  text.gsub!(/<img src="http:\/\/polit-gramota.ru\/images\/([^"]*)"(?: style="float: (\w+);[^"]*")?[^>]*>/) do
    img = $~[1]
    images << img
    style = $~[2].nil? ? "" : "(#{$~[2]})"
    "!#{style}#{Link.make_link_text(img.gsub('.jpg',''))}!"
  end
  
  
  text.gsub!(/<a href="(.+?)">(.+?)<\/a>/) do
    link = $~[1]; link_text = $~[2] 
    link.gsub!('http://polit-gramota.ru','') 
    link_text = "\"#{link_text}\"" if not link_text.match(/^!(.+?)!$/) # Это не изображение, текст ссылки в кавычки
    "#{link_text}:#{link}"
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
cb = User.find_by_email('bot@polit-gramota.ru') 
if not cb.kind_of? User
  puts 'Convert bot not found'
  exit
end
 
puts "Convert bot: #{cb.name}"

puts "Deleting categories..."
Category.destroy_all
# puts "Deleted #{deleted_cats.size} earlier converted revisions"
puts "Importing categories..."
DBConn.connection.select_all('SELECT * FROM categories').each do |c|
  # pp c
  
  cat = Category.create(:cat_type=>c['type'], :title=>c['title'], :archived => %w{top archived news}.include?(c['type']))
  cat_link = cat.links.create(:text => c['link'], :editor => cb) 
  cat.save
end

nil_cat = Category.create(:title=>'(Без рубрики)', :archived => 1)
puts "Deleting images..."
Image.destroy_all
puts "Deleting articles..."
Revision.destroy_all
puts "Importing articles..."
# puts "Deleted #{deleted_revs.size} earlier converted revisions"
DBConn.connection.select_all('SELECT articles.*, categories.link as category_link FROM articles LEFT JOIN  categories ON articles.categoryId=categories.id').each do |a|
  lead, lead_images = html2textile(a['lead'])
  text, text_images = html2textile(a['text'])
  
  (lead_images.to_a | text_images.to_a).each do |i|
    
    img = Image.find_or_create_by_title(:title => i.gsub('.jpg',''), :image_path => "#{RAILS_ROOT}/images/#{i}" )
    
    if not img.save
      p img
      img.errors.each{|attr,msg| puts "#{attr} - #{msg}" }
    end
    # pp img
  end
  
  a['date'] = Time.parse('2009-01-01').to_i.to_s if a['category_link'] == 'about'
  art = Article.new(
    :title => a['title'],
    :subtitle => a['subtitle'],
    :publication_date => Time.at(a['date'].to_i),
    :text => text,
    :lead => lead,
    :editor => cb
  )
  
  art.category = Link.find_by_text(a['category_link']).linked rescue nil_cat
   
  if not art.save
    p art
    art.errors.each{|attr,msg| puts "#{attr} - #{msg}" }  
  end
  
  art.links.create(:text => a['link'], :editor => cb) 
  
    #   
  # p art
end
