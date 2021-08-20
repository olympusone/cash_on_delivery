module Spree
    module Adjustable
      module Adjuster
        class PaymentMethod < Spree::Adjustable::Adjuster::Base
          def update
            if @adjustable.order.cash_on_delivery?
              payment_total = 2.5
              
              update_totals(payment_total)
            end
          end
  
          private
  
          def update_totals(payment_total)
            payment_total ||= 0.0

            @totals[:taxable_adjustment_total] += payment_total
          end
        end
      end
    end
  end