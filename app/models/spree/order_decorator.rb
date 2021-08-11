module Spree::OrderDecorator
    def cash_on_delivery?
        payments.where(state: ['checkout', 'pending']).map { |m| m.payment_method.type }.include? "Spree::PaymentMethod::CashOnDelivery"
    end
end
  
::Spree::Order.prepend(Spree::OrderDecorator) if ::Spree::Order.included_modules.exclude?(Spree::OrderDecorator)
