# frozen_string_literal: true

class RemoveColumnsFromMovies < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :production_companies, :string
    remove_column :movies, :production_country, :string
  end
end
