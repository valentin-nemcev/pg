# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#

Navigation.create :name => 'tag_line', :title => 'Движения'

Navigation.create :name => 'tag_nav_big',    :title => 'Меню 1'
Navigation.create :name => 'tag_nav_medium', :title => 'Меню 2'
Navigation.create :name => 'tag_nav_small',  :title => 'Меню 3'
