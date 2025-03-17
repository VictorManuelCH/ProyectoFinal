class CreateOrderStates < ActiveRecord::Migration[7.0]
  def change
    create_table :order_states do |t|
      t.references :order, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
