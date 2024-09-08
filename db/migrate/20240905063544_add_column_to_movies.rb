class AddColumnToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :release_date_time, :datetime
  end
end
