class AdminController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  
  protected

    class << self

      attr_reader :parents
      
      # class_inheritable_accessor :parents
      
      def parent_resources(*parents)
        @parents = parents
      end

    end

    def parent_id(parent)
      request.path_parameters["#{ parent }_id"]
    end

    def parent_type
      self.class.parents.detect { |parent| parent_id(parent) }
    end

    def parent_class
      parent_type && parent_type.to_s.classify.constantize
    end

    def parent_object
      parent_class && parent_class.find_by_id(parent_id(parent_type))
    end
end
