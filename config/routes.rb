ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :articles
    admin.resources :categories
  end  
  
end
