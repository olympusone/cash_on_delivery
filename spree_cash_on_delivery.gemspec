# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_cash_on_delivery/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_cash_on_delivery'
  s.version     = SpreeCashOnDelivery.version
  s.summary     = 'Spree Cash On Delivery'
  s.description = ''
  s.required_ruby_version = '>= 2.7.3'

  s.author    = 'OlympusOne'
  s.email     = 'support@olympusone.com'
  s.homepage  = 'https://github.com/olympusone/spree_cash_on_delivery'
  s.license = 'BSD-3-Clause'

  s.files       = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 4.2.5', '< 6.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
