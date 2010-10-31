module Admin::NavigationHelper

  def navigation_link(condition, name, options = {}, html_options = {}, &block)
    if condition
      html_options[:class] = 'current'
      content_tag :span, name, html_options
    else
      link_to(name, options, html_options)
    end
  end
    
end