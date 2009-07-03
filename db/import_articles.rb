#!/usr/bin/env /Users/valentine/Work/Polit-gramota/pg/script/runner

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
  text.gsub!('</p>', "\n") # Расставили абзацы...
  text.gsub!(/<br[^>]*>/, "\n") # ...и переносы строк
  text.gsub!(/<\/?[^>]*>/, '') # Выкинули теги
  text = coder.decode(text) # Заменили html entities
  
  
end
  
cb = User.find_by_name('ConvertBot')    
deleted_revs = Revision.destroy_all(:editor_id => cb)
puts "Deleted #{deleted_revs.length} earlier converted revisions"
DBConn.connection.select_all('SELECT * FROM articles LIMIT 5 ').each do |a|
  art = Article.create
  art.current_revision = art.revisions.create(
    :title => a['title'],
    :subtitle => a['subtitle'],
    :publication_date => a['date'],
    :text => html2textile(a['text']),
    :lead => html2textile(a['lead']),
    :editor => cb
  )
  art.save
  art.canonical_link = art.links.create(:text => a['link'], :linked => art, :editor => cb)
  
  p art
end
