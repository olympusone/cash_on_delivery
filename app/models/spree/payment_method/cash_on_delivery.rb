module Spree
    class PaymentMethod::CashOnDelivery < ::Spree::PaymentMethod
      def payment_profiles_supported?
        false # we do not want to show the confirm step
      end

      def update_adjustment(adjustment, src)
        adjustment.update_attribute_without_callbacks(:amount, Spree::Config[:cash_on_delivery_charge])
      end

      def actions
        %w{capture void}
      end
  
      # Indicates whether its possible to capture the payment
      def can_capture?(payment)
        return false if payment.completed?
        payment.order.shipments.all? do |shipment|
          shipment.state == 'shipped'
        end
      end
  
      # Indicates whether its possible to void the payment.
      def can_void?(payment)
        payment.state != 'void'
      end
  
      def capture(*args)
        ActiveMerchant::Billing::Response.new(true, "", {}, {})
      end
  
      def cancel(response); end
  
      def void(*args)
        ActiveMerchant::Billing::Response.new(true, "", {}, {})
      end
  
      def source_required?
        false
      end

      def payment_source_class
        nil
      end
  
      def method_type
        'cash_on_delivery'
      end

      def cash_on_delivery?
        true
      end

      def apply_adjustment(order)
        label = I18n.t(:charge_label, scope: :cash_on_delivery)
  
        remove_charges(order)
        order.adjustments.create!(
          amount: compute_charge.call(order),
          label: label,
          order: order
        )
        order.update!
      end
  
      def compute_commission(order)
        compute_charge.call(order)
      end
  
      private
  
      def compute_charge
        Rails.application.config.cash_on_delivery_charge if defined?(Rails)
      end
    end
end