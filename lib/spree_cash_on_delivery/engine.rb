module SpreeOrderComments
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_order_comments'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.after_initialize do
      Spree::PermittedAttributes.checkout_attributes << :comments
      Spree::PermittedAttributes.line_item_attributes << :comments

      Spree::Api::Dependencies.storefront_cart_serializer = 'CartSerializer'

      config.spree.line_item_comparison_hooks.add 'compare_line_item_comments'
    end

    initializer 'spree_order_comments.environment', before: :load_config_initializers do |_app|
      SpreeOrderComments::Config = SpreeOrderComments::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
