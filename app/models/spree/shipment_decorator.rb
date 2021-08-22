module Spree::ShipmentDecorator
    def determine_state(order)   
        return 'ready' if cash_on_delivery? && !shipped?
        
        return 'canceled' if order.canceled?
        return 'pending' unless order.can_ship?
        return 'pending' if inventory_units.any? &:backordered?
        return 'shipped' if shipped?

        return order.paid? || Spree::Config[:auto_capture_on_dispatch] ? 'ready' : 'pending'
    end

    private
    def cash_on_delivery?
        order.payments.any? do |payment|
          payment.payment_method.type == "Spree::PaymentMethod::CashOnDelivery" && !payment.void?
        end
    end
end
  
::Spree::Shipment.prepend(Spree::ShipmentDecorator)