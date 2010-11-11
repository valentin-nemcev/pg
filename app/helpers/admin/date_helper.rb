module Admin::DateHelper

  def format_date(date)
    Russian.strftime(date, "%d %B %Y, %H:%M")
  end 

end
