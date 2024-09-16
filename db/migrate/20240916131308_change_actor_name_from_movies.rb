class ChangeActorNameFromMovies < ActiveRecord::Migration[7.1]
  def change
    change_column :movies, :actor_name, :string, array: true, default: [], using: 'string_to_array(actor_name, \',\')'
  end
end
