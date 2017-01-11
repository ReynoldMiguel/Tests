require_relative "spec_helper"
require_relative '../pageobjects/home_page'
require_relative '../pageobjects/search_page'

describe "BBC.com Search" do
  it "search text on bbc.com" do
  	search_term = 'World Market'
    expected = 0

    home_page = HomePage.new(@browser, true)
    home_page.look_for(search_term)

    # Loop 10 times to view next 10 pages
    10.times do
      search_page = @browser
      section_list = search_page.section(class: 'search-content')
      actual = section_list.lis.size

      # The number of articles displaying is cumulative
      expected = expected + 10
      expect(actual).to be == expected

      # View more results and wait for page to load
      search_page.link(:class, "more").click
      search_page.link(:class, "more").wait_until_present
    end

    #puts @browser.text
    string = "London"
    count  = @browser.text.scan(/(#{string})/).count

    puts
    puts "The Search Term of '#{search_term}' contains #{count} references to articles relating to the word '#{string}'."
  end

end
