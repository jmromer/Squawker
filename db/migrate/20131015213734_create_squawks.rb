# frozen_string_literal: true

class CreateSquawks < ActiveRecord::Migration
  def change
    create_table :squawks do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end

    add_index :squawks, %i[user_id created_at]
  end
end
