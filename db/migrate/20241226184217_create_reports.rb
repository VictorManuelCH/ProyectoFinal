# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
