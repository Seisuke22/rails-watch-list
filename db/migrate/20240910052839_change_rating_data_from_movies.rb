# frozen_string_literal: true

class ChangeRatingDataFromMovies < ActiveRecord::Migration[7.1]
  def change
    change_column :movies, :rating, :integer
  end
end
