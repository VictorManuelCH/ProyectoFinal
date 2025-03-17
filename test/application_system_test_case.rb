require "test_helper"
require "capybara/rails"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--disable-features=NetworkService,NetworkServiceInProcess")
  
  # Establecer un directorio único para evitar el error "user data directory is already in use"
  options.add_argument("--user-data-dir=/tmp/chrome-user-data")

  if ENV["GITHUB_ACTIONS"]
    options.add_argument("--headless") # Solo en GitHub Actions para ejecutar en modo headless
  end

  driven_by :selenium, using: :chrome, options: { browser: :chrome, options: options }
end

