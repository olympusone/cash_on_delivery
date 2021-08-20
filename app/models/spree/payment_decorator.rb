module Spree::PaymentDecorator
    def self.prepended(base)
        base.has_one :adjustment, as: :adjustable, dependent: :destroy
    end

    def build_source
        return if source_attributes.nil?
    
        if payment_method and payment_method.respond_to?(:post_create)
          payment_method.post_create(self)
        end
    
        if payment_method and payment_method.payment_source_class
          self.source = payment_method.payment_source_class.new(source_attributes)
        end  
    end
end
  
::Spree::Payment.prepend(Spree::PaymentDecorator)