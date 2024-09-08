class AddProductionCountryToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :production_country, :string
  end
end
