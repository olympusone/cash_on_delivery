module SpreeCashOnDelivery
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_cash_on_delivery'

    # config.autoload_paths += %W(#{config.root}/lib)

    initializer 'spree.register.payment_methods', before: :load_config_initializers do |_app|
      # _app.config.spree.payment_methods << Spree::PaymentMethod::CashOnDelivery
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    # initializer 'spree_cash_on_delivery.environment', before: :load_config_initializers do |_app|
    #   SpreeCashOnDelivery::Config = SpreeCashOnDelivery::Configuration.new
    # end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/spree/*_decorator*.rb')) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)

      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../lib/active_merchant/**/*_decorator*.rb')) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

    #   if self.frontend_available?
    #     Dir.glob(File.join(File.dirname(__FILE__), '../../lib/spree_frontend/controllers/spree/*_decorator*.rb')) do |c|
    #       Rails.application.config.cache_classes ? require(c) : load(c)
    #     end
    #   end
    end

    # def self.backend_available?
    #   @@backend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Backend::Engine')
    # end

    # def self.frontend_available?
    #   @@frontend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Frontend::Engine')
    # end

    # if self.backend_available?
    #   paths["app/views"] << "lib/views/backend"
    # end

    # paths['app/controllers'] << 'lib/controllers'

    # if self.frontend_available?
    #   paths["app/controllers"] << "lib/spree_frontend/controllers"
    #   paths["app/views"] << "lib/views/frontend"
    # end

    config.to_prepare(&method(:activate).to_proc)
  end
end
