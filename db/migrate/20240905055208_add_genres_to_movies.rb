class AddGenresToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :genres, :string
  end
end
