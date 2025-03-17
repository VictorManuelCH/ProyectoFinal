class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_state
  belongs_to :payment_method
end
