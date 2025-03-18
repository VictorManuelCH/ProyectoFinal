# frozen_string_literal: true

json.array! @payment_methods, partial: 'payment_methods/payment_method', as: :payment_method
