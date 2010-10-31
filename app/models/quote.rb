class Quote < ActiveRecord::Base
  validates_presence_of :text
  
  def self.find_random(seed)
    old = srand(seed.to_i)
    id = rand(self.count)
    srand(old)
    self.all[id]
  end
end
