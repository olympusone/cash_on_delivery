module Spree::OrderDecorator
    def cash_on_delivery?
        payments.where.not(state: ['failed', 'void'])
            .map { |m| m.payment_method.type }
            .include?("Spree::PaymentMethod::CashOnDelivery")
    end
end
  
::Spree::Order.prepend(Spree::OrderDecorator)
