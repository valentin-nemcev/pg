class AddDontExportToYandexToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :dont_export_to_yandex, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :dont_export_to_yandex
  end
end
