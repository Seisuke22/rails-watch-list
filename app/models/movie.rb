class Movie < ApplicationRecord
  has_many :bookmarks

  validates :title, uniqueness: true
  validates :release_year, :overview, :poster_url, :runtime, :trailer_url, :images_url, presence: true
  validates :rating, :release_year, numericality: { only_integer: true }
end
