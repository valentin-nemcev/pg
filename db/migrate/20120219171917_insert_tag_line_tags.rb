class InsertTagLineTags < ActiveRecord::Migration
  def self.up
    tag_line = Navigation.find_or_create_by_name :name => 'tag_line', :title => 'Движения'
    tag_line.tag_string = 'ЕР, КПРФ, ЛДПР, Наши, Оборона, Правое дело, РНДС, РСДСМ, СР, ФСМ, Яблоко'

  end

  def self.down
  end
end
