class Admin::MainController < AdminController
  def main
    @articles = Hash.new
    @images = Hash.new
    @articles[:total] = Article.count
    @images[:total] = Image.count
  end

end
