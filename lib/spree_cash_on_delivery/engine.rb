module SpreeCashOnDelivery
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_cash_on_delivery'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_cash_on_delivery.environment', before: :load_config_initializers do |_app|
      SpreeCashOnDelivery::Config = SpreeCashOnDelivery::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree.register.payment_methods', before: :load_config_initializers do |_app|
      app.config.spree.payment_methods << Spree::PaymentMethod::CashOnDelivery
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
