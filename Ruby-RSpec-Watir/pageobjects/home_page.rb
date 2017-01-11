require 'page-object'
require 'watir'

class HomePage
  include PageObject

  page_url('http://www.bbc.com/')

  text_field(:search_field, id: 'orb-search-q')
  button(:search_button, class: 'se-searchbox__submit')
  div(:footer_section, id: 'orb-contentinfo')

  def look_for(keyword)
    self.search_field = keyword; sleep 5
    self.search_button; sleep 5
  end

end