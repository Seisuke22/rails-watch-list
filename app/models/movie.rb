class Movie < ApplicationRecord
  has_many :bookmarks

  validates :title, uniqueness: true
  validates :release_year, :overview, :poster_url, :trailer_url, :images_url, presence: true
end
