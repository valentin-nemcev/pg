module HasURI
  def self.included base #:nodoc:
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_uri(uri_field)
      
      before_save :generate_uri
      cattr_accessor :uri_field
      self.uri_field = uri_field
      include InstanceMethods
    end
    
    
  end
  
  module InstanceMethods
    def generate_uri
      uri = Russian.translit(read_attribute(self.class.uri_field)).parameterize
      base_uri = String.new uri
      counter = 2
      while self.class.exists?  ["uri = ? AND id <> #{self.id.to_i}", uri]
        uri = base_uri + "--#{counter}"
        counter += 1
      end
      write_attribute(:uri, uri)
    end
  end
end