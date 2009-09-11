module Admin::BreadcrumbsHelper
  def breadcrumbs(url)
    names = {'admin' => 'Управление', 'articles' => t('.article')}
		breadcrumbs = []
    sofar = '/'
    elements = url.split('/')
		elements.shift
    elements.each_with_index do |elm, i|
      sofar += elm + '/' 
      
      if i>0  
        begin
  			  klass=elements[i-1].classify.constantize 
  			  if klass.ancestors.include? ActiveRecord::Base
  			    name = '«' + truncate(klass.find(elm).title, :length => 25) + '»' 
  		    end
  		  rescue NameError, ActiveRecord::RecordNotFound
  		  end   
		  end
		  
		  name ||= t "breadcrumbs.#{elm}", :default => elm
            
      if i < (elements.length - 1)
				breadcrumbs << "<td class=\"link\"><a href='#{sofar}'>#{name}</a></td>"
			else
        # breadcrumbs << '<td class="current">'+name+'</td>'
			end
    end
    breadcrumbs * '<td class="separator"> → </td>'
  # rescue
  #     'Not available'
  end
end