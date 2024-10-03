# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :movie
  belongs_to :list
  belongs_to :user

  validates :comment, length: { minimum: 6 }
  validates_uniqueness_of :movie_id, scope: :list_id
end
