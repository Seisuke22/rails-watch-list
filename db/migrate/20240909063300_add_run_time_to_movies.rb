class AddRunTimeToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :runtime, :integer
  end
end
