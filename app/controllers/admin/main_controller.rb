class Admin::MainController < AdminController
  def main
    @articles = Hash.new
    @articles[:total] = Article.count
  
  end

end
