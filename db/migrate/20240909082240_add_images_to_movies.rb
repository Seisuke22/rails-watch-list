# frozen_string_literal: true

class AddImagesToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :images_url, :string
  end
end
