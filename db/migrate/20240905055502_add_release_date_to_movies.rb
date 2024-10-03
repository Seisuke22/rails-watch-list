# frozen_string_literal: true

class AddReleaseDateToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :release_date, :string
  end
end
