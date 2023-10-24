# /spec/support/capybara.rb
# Add the following line in rails_helper.rb to load this configuration.
#
#   require_relative 'support/capybara'
#

RSpec.configure do |config|
  # Test Drivers - https://everydayrails.com/2018/01/08/rspec-3.7-system-tests.html
  config.before(:each, type: :system) do
    # Whether :js is true or not, this block will run when "type: :system"

    driven_by :rack_test # Use :rack_test for faster execution, but it won't save pictures
    # driven_by :selenium_chrome # Use :selenium_chrome to see the browser
    # driven_by :selenium_chrome_headless # Use :rack_test for faster execution, but :selenium can save pictures
  end

  config.before(:each, type: :system, js: true) do
    # When 'js: true' is added, this will "also" run and override the driver choice

    driven_by :selenium_chrome_headless
  end

  # Capybara.asset_host = 'http://localhost:3000' # For better looking HTML screenshots
  # To use subdomain in the local environment, lvh.me is helpful to refer localhost easily
  # Example:
  #   Capybara.app_host = 'http://lvh.me'

  # Capybara::Screenshot.prune_strategy = :keep_last_run # Remove old files

  # Devise
  # For Devise Log-in - https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  # config.include Warden::Test::Helpers

  # To make sure Devise log-in works correctly, reset warden after each test
  # config.after(:each, type: :system) do
  #   Warden.test_reset!
  # end
end