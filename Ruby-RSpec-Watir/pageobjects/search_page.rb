require 'page-object'
require 'watir'

class SearchPage
  include PageObject

  link(:more, class: 'more')

end