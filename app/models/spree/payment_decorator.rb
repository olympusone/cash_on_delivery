module Spree::PaymentDecorator
    def self.prepended(base)
        base.has_one :adjustment, as: :source, dependent: :destroy

        base.after_create :set_adjustment
        base.before_update :update_adjustment
    end
    
    private
    
    def set_adjustment
        if payment_method.type == "Spree::PaymentMethod::CashOnDelivery"
            label = I18n.t('cash_on_delivery.charge_label')

            build_adjustment(
                amount: 2.5,
                label: label,
                order: order,
                included: false,
                state: 'closed',
                adjustable: order         
            )

            adjustment.save
            
            order.update_totals
            order.persist_totals

            update_columns(
                amount: order.total,
                updated_at: Time.current
            )
        end
    end

    def update_adjustment
        if payment_method.type == "Spree::PaymentMethod::CashOnDelivery" && void?
            adjustment.update(eligible: false) 
            order.update_totals
            order.persist_totals
        end
    end
end
  
::Spree::Payment.prepend(Spree::PaymentDecorator)