# frozen_string_literal: true

json.array! @payment_states, partial: 'payment_states/payment_state', as: :payment_state
