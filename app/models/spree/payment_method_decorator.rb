module Spree::PaymentMethodDecorator
    # MONEY_THRESHOLD  = 100_000_000
    
    # MONEY_VALIDATION = {
    #     presence: true,
    #     numericality: {
    #     greater_than: -MONEY_THRESHOLD,
    #     less_than: MONEY_THRESHOLD,
    #     allow_blank: true
    #     },
    #     format: { with: /\A-?\d+(?:\.\d{1,2})?\z/, allow_blank: true }
    # }.freeze

    # POSITIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
    #     validation.fetch(:numericality)[:greater_than_or_equal_to] = 0
    # end.freeze

    # NEGATIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
    #     validation.fetch(:numericality)[:less_than_or_equal_to] = 0
    #     end.freeze
        
    def self.prepended(base)
        base.preference :charge, :string
        # base.extend Spree::DisplayMoney

        # base.money_methods :charge    
    
        # base.validates :charge, POSITIVE_MONEY_VALIDATION
    end

    def charge
        preferences[:charge].to_f
    end
end
  
::Spree::PaymentMethod.prepend(Spree::PaymentMethodDecorator)