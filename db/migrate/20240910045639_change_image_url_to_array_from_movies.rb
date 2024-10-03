# frozen_string_literal: true

class ChangeImageUrlToArrayFromMovies < ActiveRecord::Migration[7.1]
  def up
    # Convert the column to an array type
    change_column :movies, :images_url, :string, array: true, default: [], using: "string_to_array(images_url, ',')"
  end

  def down
    # Revert the column back to a single string
    change_column :movies, :images_url, :string
  end
end
