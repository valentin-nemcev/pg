ActionController::Routing::Routes.draw do |map|
  
  
  map.namespace :admin, :path_prefix => '__adm' do |admin|
    admin.root :controller => "main", :action => "main"    
    
    admin.resources :layout_cells, 
      :except => [:show, :edit, :new],
      :member => [:move_side] do |layout_cell|
        layout_cell.resources :layout_items, :except => [:show, :edit,:update], :member => {:move => :post} 
    end
      
    admin.resources :quotes, :except => [:show], :collection => { :new => [:get, :post] } 
    
    # links_route_params = {:except => [:show, :edit], :member => { :make_canonical => :post }, :collection => { :new => [:get, :post] }}
    
    # admin.resources :links, links_route_params
    
    # admin.resources :categories, :except => [:show], :member => [:move], :collection => { :new => [:get, :post] } do |c|
    #   c.resources :links, links_route_params
    #   c.resources :articles, :has_many => [:images], :collection => { :new => [:get, :post] } do |a2|
    #     a2.resources :links, links_route_params
    #     a2.resources :revisions, :except => :edit 
    #   end
    # end
    
    admin.resources :comments, :only => [:index, :destroy]

    admin.resources :articles, :has_many => [:images], :collection => {:search => [:get], :tag => [:post]} do |a|
      # a.resources :links, links_route_params
      # a.resources :revisions, :except => :edit 
    end
    
    admin.resources :tags, :member => {:merge => [:post]}
    
    admin.resources :images, :has_many => [:articles], 
                         :member => { :crop_form => :get},
                         :collection => { :new => [:get, :post] } 
        
    admin.logout '/logout', :controller => 'sessions', :action => 'destroy'
    admin.login '/login', :controller => 'sessions', :action => 'new'
    admin.register '/register', :controller => 'users', :action => 'create'
    admin.signup '/signup', :controller => 'users', :action => 'new'
    admin.resources :users, :collection => { :new => [:get, :post] }
    admin.resource :session
  end  
  
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  
  map.with_options :controller  => 'site' do |site|
    site.root  :action => "main"
    site.search "/search", :action => "search"
    site.feed "/feed", :action => 'feed', :format => 'rss'
    site.article "/articles/:article_uri", :action => "article"
    site.post_comment "/articles/:article_uri/post_comment", :action => "post_comment"
    site.all_tags "/tags/", :action => "all_tags"
    site.tag "/tags/:tag_uri", :action => "tag"  
    site.legacy_uri "*legacy_uri", :action => "legacy_uri"
    
  end

end
