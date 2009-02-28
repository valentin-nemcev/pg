ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    #map.resources :articles
    admin.resources :categories, :has_many => :articles
  end  
  
end
