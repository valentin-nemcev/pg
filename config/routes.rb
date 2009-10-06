ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.root :controller => "main", :action => "main"    
    
    admin.resources :layout_items, :except => [:show, :edit, :new]
    
    admin.resources :quotes, :except => [:show], :collection => { :new => [:get, :post] } 
    admin.resources :links, :except => [:show]
    
    admin.resources :articles, :has_many => [:revisions, :links, :images], :collection => { :new => [:get, :post] } 
    admin.resources :revisions, :except => :edit 
    
    admin.resources :categories, :has_many => [:articles],  :except => [:show]
    admin.resources :images, :has_many => [:articles], 
                    :member => { :thumb => :get }, :collection => { :new => [:get, :post] } 
    
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.login '/login', :controller => 'sessions', :action => 'new'
    admin.register '/register', :controller => 'users', :action => 'create'
    admin.signup '/signup', :controller => 'users', :action => 'new'
    admin.resources :users, :member => {:increment_bug_counter => :get}
    admin.resource :session
  end  
  
  map.root :controller => "site", :action => "main"
  # map.category ":category_link/", :controller => "site", :action =>"category"
  map.article ":article_link", :controller => "site", :action => "article"
  map.category "/category/:category_link", :controller => "site", :action => "category"  
  map.image '/images/:image_link', :controller => 'site', :action => 'image'
end
