require "rspec/expectations"
require "watir"
require "rspec"

RSpec.configure do | config |

  config.before(:each) do | x |
    capabilities_config = {
      :version => "#{ENV['version']}",
      :browserName => "#{ENV['browserName']}",
      :platform => "#{ENV['platform']}",
      :name => x.full_description
    }

    url = "https://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:443/wd/hub".strip

    client = Selenium::WebDriver::Remote::Http::Default.new

    puts "Remote run?  #{ENV['remote']}"
    if "#{ENV['remote']}" == 'true'
      # Remote Run
      @browser = Watir::Browser.new(:remote, :url => url, :desired_capabilities => capabilities_config, :http_client => client)
    else
      # Local Run - Specify the driver path
      chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"Ruby-RSpec-Watir","chromedriver")
      @browser = Watir::Browser.new :chrome, :driver_path => chromedriver_path
    end

  end

  config.after(:each) do | example |
    sessionid = @browser.driver.send(:bridge).session_id
    @browser.quit
  end

end
