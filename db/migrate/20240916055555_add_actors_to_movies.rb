# frozen_string_literal: true

class AddActorsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :actor_name, :string
    add_column :movies, :actor_image, :string
  end
end
