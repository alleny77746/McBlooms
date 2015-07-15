require "mocha/setup"
RSpec.configure do |config|
  config.mock_with :mocha
  config.mock_framework = :mocha
end