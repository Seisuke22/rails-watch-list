class Movie < ApplicationRecord
  has_many :bookmarks

  validates :title, uniqueness: true
  validates :actor_name, :actor_image, :release_year, :overview, :poster_url, :trailer_url, presence: true
end
