# frozen_string_literal: true

class ChangeOverviewToStringInMovies < ActiveRecord::Migration[7.1]
  def change
    change_column :movies, :overview, :string
  end
end
