module Admin::FormsHelper
  def vertical_text(text)
    text.split('').join('<br/>')
  end
  
end
