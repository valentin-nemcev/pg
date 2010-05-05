class Article < ActiveRecord::Base

  
  
  has_many :layout_cells, :through => :layout_items
  has_many :comments
  
  # @@per_page = 10
  


  
  
  has_and_belongs_to_many :images, :order => 'updated_at DESC'
  
  has_and_belongs_to_many :tags, :order => 'name ASC'
  
  define_index do 
    indexes title
    indexes subtitle
    indexes lead
    indexes text
    
    has publication_date
  end
  
  validates_presence_of :title 
  validates_length_of :title, :in => 3..250
  
  ordered_by 'publication_date DESC'
  
  default_scope :include => :tags
  
  
  before_save :parse_text_fields
  
  has_uri :title
  
  named_scope :with_tags , lambda { |tags|
    {:joins => :tags, :conditions => {:tags => {:id => Tag.find_by_tag_list(tags)}}}
  }
  
  named_scope :with_text, lambda { |text|
    ids = self.search_for_ids(text, :per_page => 10_000)
    order = "field(`articles`.id, #{ids.join(',')})" unless ids.empty?
    {:conditions => {:id => ids}, :order => order}
  }

  
  named_scope :for_select, {:select => 'id, title, publication_date', :order => "publication_date DESC"}
  named_scope :publicated, {:conditions => ["is_publicated and publication_date <= NOW()"]}


  
  def similar
    self.class.all :joins => :tags, 
      :conditions => {:tags => {:id => self.tags.collect(&:id)}},
      :group => '`articles`.id',
      :order => 'count(tags.id) DESC, publication_date DESC',
      :limit => 7
  end
  
  def tag_string
    self.tags.collect(&:name).join(', ')
  end
  
  def tag_string=(tags)
    self.tags = Tag.find_or_create_by_tag_list(tags)
  end
  
  def publicated?
    self.is_publicated and self.publication_date <= Time.now
  end
  
  def convert_legacy_fields
    %w{lead text}.each do |field|
      write_attribute(field, legacy_html_to_textile(read_attribute("legacy_#{field}")))
    end
    return self
  end  
  
  protected

    
    def legacy_html_to_textile(legacy_html)

      legacy_html.gsub!('&shy;', '') # Выкинули мягкие переносы
      legacy_html.gsub!('­', '') # Выкинули мягкие переносы
      legacy_html.gsub!(/\s+/, ' ')

      require 'hpricot'
      doc = Hpricot(legacy_html) 

      (doc/'br').map { |el| el.swap("\n") }
      
      (doc/'strong, em, p').map!{ |el| el if el.inner_html.blank? }.compact.remove
      
      (doc/'p').map!{ |el| el if el.inner_html == '&nbsp;' }.compact.remove
      
      (doc/'strong, em').map do |el|
        content = el.inner_html
        bs = ' ' if content[0] == ?\s
        as = ' ' if content[-1] == ?\s
        tag = case el.name 
          when 'strong' then '*'
          when 'em' then '_'
        end
        el.swap("#{bs}#{tag}#{content.strip}#{tag}#{as}") 
      end
      

      (doc/'ul'/'li').map { |el| el.swap("* #{el.inner_html}\n") }
      (doc/'ol'/'li').map { |el| el.swap("# #{el.inner_html}\n") }
      (doc/'ul').map { |el| el.swap("#{el.inner_html}\n") }

      (doc/'h6').map { |el| el.swap("h4. #{el.inner_html}\n\n") }
      (doc/'h5').map { |el| el.swap("h3. #{el.inner_html}\n\n") }

      (doc/'p').each { |p| p.swap(p.inner_html) unless (p/'p').empty? }

      (doc/'p').map do |el| 
        unless el['class'].blank? || el['class'] == 'MsoNormal'
          с = el['class'].sub('script', 'signature')
          prefix = "p(#{с}). " 
        end
        el.swap("#{prefix}#{el.inner_html}\n\n") 
      end

      (doc/'a').map do |el| 
        href = el['href'].gsub('http://polit-gramota.ru','') 
        text = el.inner_text.gsub("\n", '')
        el.swap(%Q{["#{text}":#{href}]})
      end

      (doc/'img[@src="http://polit-gramota.ru/images/3x3.jpg"]').remove
      
      (doc/'img').map do |el| 
        src = el['src'] 
        if src.include? 'http://polit-gramota.ru/images/'
          file_name = src.sub('http://polit-gramota.ru/images/', '')
          # if file_name == '3x3.jpg'
          img = Image.find_or_create_by_legacy_file_name(file_name)
          img.image = File.open(File.join(RAILS_ROOT, 'legacy_images', file_name)) if img.new_record?
          img.save!
          src = img.id
          css_class = "(legacy)"
        end
        if el['style'] && el['style'].match(/float: (\w+);/)
          align = case $~[1]
            when 'left' then '<'
            when 'right' then '>'
          end
        end
        el.swap("!#{align}#{css_class}#{src}!") 
      end

      textile = doc.to_html 
      require 'htmlentities'
      textile = HTMLEntities.new.decode(textile)
      textile.gsub!(/^ +/, '')
      textile.gsub!(/\n{2,}/, "\n\n")
      textile.gsub!(/^\*(.+?)\*$/, 'h4. \1')
      textile
    end
    
    module RedCloth::Formatters::HTML
      def image(opts)
        opts[:class] ||= ''
        opts[:class] = opts[:class].split(' ').push(opts.delete(:align)).compact.join(' ')
        opts[:alt] = opts[:title]
        img = "<img src=\"#{escape_attribute opts[:src]}\"#{pba(opts)} alt=\"#{escape_attribute opts[:alt].to_s}\" />"  
        img = "<a href=\"#{escape_attribute opts[:href]}\">#{img}</a>" if opts[:href]
        img
      end
      def p(opts)
        opts.delete(:float)
        "<p#{pba(opts)}>#{opts[:text]}</p>\n"
      end
      
      def quote2(opts)
        "&laquo;#{opts[:text]}&raquo;"
      end
      
      def multi_paragraph_quote(opts)
        "&laquo;#{opts[:text]}&raquo;"
      end
      
      def endash(opts)
        " &mdash; "
      end
    end
    
    def set_typography(text, options = {})
      nbsp = " "
      quot = options.delete(:plain) ? '"' : "&quot;"
      text = text.clone
      
      # text.gsub!('&quot;', '"')
      text.gsub!(/(^|\s)#{quot}([а-яА-Я\w])/, '\1«\2')

      text.gsub!(/(\S)#{quot}([^а-яА-Я\w\d]|$)/, '\1»\2')

      text.gsub!(/»#{quot}([^а-яА-Я\w\d]|$)/, '\1»»\3')
      text.gsub!(/#{quot}»([^а-яА-Я\w\d]|$)/, '»»\2')
      
      while m = /(«)([^»]*)(«)([^»]*)(»)/.match(text) do
        text.gsub!(m[0], "#{m[1]}#{m[2]}„#{m[4]}“")
      end
      
      text.gsub!(/ (-|–) /, " — ")
      text.gsub!(/(\n|>)(-|–) /, '\1— ')
      
      return text
    end
    
    def parse_text_fields
      %w{title subtitle}.each do |field|
        next if read_attribute(field).nil?
        write_attribute(field + '_html', set_typography(read_attribute(field), :plain => true))
      end

      require 'hpricot'
      self.images.clear      

      %w{lead text}.each do |field|
        next if read_attribute(field).nil?
        
        attrib = read_attribute(field)
        # p attrib
        doc = Hpricot(RedCloth.new(attrib).to_html)

        (doc/"img").each do |img|
          image = Image.find_by_id(img.attributes['src']) or next
          self.images << image unless self.images.exists?(image.id)
          img.attributes['src'] = image.url
        end

        write_attribute(field + '_html', set_typography(doc.to_html))
      end
      
      true
    end
end