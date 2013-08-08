require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '.bundle'
end

require 'guard/strainer'
Guard::UI.options = { :level => :warn }

RSpec.configure do |config|
  config.color = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    @fixture_path = Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end
end

# Load custom matchers
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
