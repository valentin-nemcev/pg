module SiteHelper
  def page_title(title)
    content_for :title, title + " &mdash; "
  end
end