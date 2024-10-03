# frozen_string_literal: true

class AddUserToMovies < ActiveRecord::Migration[7.1]
  def change
    add_reference :movies, :user, foreign_key: true, null: true
  end
end
