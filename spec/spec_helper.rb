unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter '.bundle'
    add_group 'PowProxy', 'lib/pow_proxy'
    add_group 'Specs', 'spec'
  end
end

require 'pow_proxy'

require 'rspec'
require 'webmock/rspec'
