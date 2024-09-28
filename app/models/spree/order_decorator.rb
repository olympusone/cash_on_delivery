module Spree::OrderDecorator
    def self.prepended(base)
        base.has_many :payment_adjustments, through: :payments, source: :adjustments
    end

    def cash_on_delivery?
        payments.where.not(state: ['failed', 'void'])
                .map { |m| m.payment_method.type }
                .include?("Spree::PaymentMethod::CashOnDelivery")
    end
end

::Spree::Order.prepend(Spree::OrderDecorator)
