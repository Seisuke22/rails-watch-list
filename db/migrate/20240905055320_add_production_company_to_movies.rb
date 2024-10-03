# frozen_string_literal: true

class AddProductionCompanyToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :production_companies, :string
  end
end
