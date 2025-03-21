# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :encrypted_password
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
