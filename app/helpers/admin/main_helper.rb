module Admin::MainHelper
  
  def form_title(record)
  end
  
  def page_title(title)
    content_for :page_title, title
    content_for :page_head_title, ["Полит-грамота: управление", title].reject(&:blank?).join(' – ')
  end
end
