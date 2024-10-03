# frozen_string_literal: true

class ChangeActorsUrlFromMovies < ActiveRecord::Migration[7.1]
  def change
    change_column :movies, :actor_image, :string, array: true, default: [], using: 'string_to_array(actor_image, \',\')'
  end
end
