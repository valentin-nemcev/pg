# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  belongs_to :article, :counter_cache => true

  validates_presence_of :body, :message => "Отсутствует текст комментария"

  before_create :set_publication_date_to_now
  def set_publication_date_to_now
    self.publication_date = Time.now
  end
  
  before_save :prepare_fields
  def prepare_fields
    self.author_name = self.author_name.strip.first(30)
    self.body = self.body.strip.first(2500)
  end

end
