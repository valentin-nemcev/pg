ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.root :controller => "main", :action => "main"    
    admin.resources :articles, :except => [:show] 
    admin.resources :categories, :except => [:show]
    admin.resources :images, :member => { :thumb => :get }
    
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.login '/login', :controller => 'sessions', :action => 'new'
    admin.register '/register', :controller => 'users', :action => 'create'
    admin.signup '/signup', :controller => 'users', :action => 'new'
    admin.resources :users, :member => {:increment_bug_counter => :get}
    
    admin.resource :session
  end  
  
  map.root :controller => "site", :action => "main"
  map.category ":category_link/", :controller => "site", :action =>"category"
  map.article ":category_link/:article_link/", :controller => "site", :action => "article"
end
