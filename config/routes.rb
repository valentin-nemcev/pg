ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root :controller => "main", :action => "main"    
    admin.resources :articles, :except => [:show] 
    admin.resources :categories, :except => [:show]
  end  
  
  map.root :controller => "site", :action => "main"
  map.article ":article", :controller => "site", :action => "article"
end
