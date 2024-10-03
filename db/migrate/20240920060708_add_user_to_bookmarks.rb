# frozen_string_literal: true

class AddUserToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookmarks, :user, foreign_key: true, null: true
  end
end
