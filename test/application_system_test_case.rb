require "test_helper"
require "capybara/rails"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["GITHUB_ACTIONS"]
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

end
