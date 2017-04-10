# frozen_string_literal: true

class AddImageLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image_url, :string
  end
end
