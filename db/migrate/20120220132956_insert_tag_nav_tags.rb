class InsertTagNavTags < ActiveRecord::Migration
  def self.up
    big = Navigation.find_or_create_by_name :name => 'tag_nav_big',    :title => 'Меню 1'
    med = Navigation.find_or_create_by_name :name => 'tag_nav_medium', :title => 'Меню 2'
    Navigation.find_or_create_by_name :name => 'tag_nav_small',  :title => 'Меню 3'
    big.tag_string = 'Репортаж, Субъектив, Дебаты'
    med.tag_string = 'Интервью, Телеверсия, Поле зрения'
  end

  def self.down
  end
end
