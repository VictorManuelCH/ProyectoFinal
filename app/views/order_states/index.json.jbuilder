# frozen_string_literal: true

json.array! @order_states, partial: 'order_states/order_state', as: :order_state
