class ChangeColumnInMovies < ActiveRecord::Migration[7.1]
  def change
    # Rename the column
    rename_column :movies, :release_date_time, :release_year

    # Change the column type to integer with explicit conversion
    change_column :movies, :release_year, :integer, using: 'EXTRACT(YEAR FROM release_year::timestamp)'
  end
end
