ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :articles, :except => [:show] 
    admin.resources :categories, :except => [:show]
  end  
  
end
