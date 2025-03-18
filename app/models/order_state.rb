# frozen_string_literal: true

class OrderState < ApplicationRecord
  belongs_to :order
  belongs_to :state
end
