# frozen_string_literal: true

class AddTrailersToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :trailer_url, :string
  end
end
