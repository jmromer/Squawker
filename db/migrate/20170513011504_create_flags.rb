# frozen_string_literal: true

class CreateFlags < ActiveRecord::Migration
  def change
    change_table :squawks do |t|
      t.integer :flags_count, default: 0, null: false
    end

    change_table :users do |t|
      t.integer :flags_count, default: 0, null: false
    end

    create_table :flags do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :squawk, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :flags, %i[user_id squawk_id], unique: true
  end
end
