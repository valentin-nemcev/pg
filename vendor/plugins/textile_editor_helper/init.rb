# Include hook code here
ActionView::Base.send :include, TextileEditorHelper

module ActionView
  module Helpers
	module FormOptionsHelper
	  def boolean_yes_no_select(object_name, method, options = {}, html_options = {})
		choices = {
		  'No'  => false,
		  'Yes' => true
		}
		InstanceTag.new(object_name, method, self, options.delete(:object)).to_select_tag(choices, options, html_options)
	  end
	end
	class FormBuilder
	  def boolean_yes_no_select(method, options = {}, html_options = {})
		@template.boolean_yes_no_select(@object_name, method, objectify_options(options), @default_options.merge(html_options))
	  end
	end
  end
end