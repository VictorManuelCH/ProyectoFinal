json.extract! payment, :id, :order_id, :total_amount, :payment_state_id, :payment_method_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
