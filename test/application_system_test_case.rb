require "test_helper"
require "capybara/rails"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = Selenium::WebDriver::Chrome::Options.new

  if ENV["GITHUB_ACTIONS"]
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1400,1400")

    driven_by :selenium, using: :chrome, options: { browser: :chrome, options: options }
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--headless') # Asegurar que se ejecute en modo headless en CI
    options.add_argument("--user-data-dir=/tmp/chrome-user-data") # Directorio único en CI
  
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  
end
