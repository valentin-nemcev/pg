class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :article
      t.string :title
      t.string :link
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
