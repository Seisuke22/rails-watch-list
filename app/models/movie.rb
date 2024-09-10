class Movie < ApplicationRecord
  has_many :bookmarks

  validates :title, uniqueness: true
  validates :release_date_time, :overview, :poster_url, :runtime, :trailer_url, :images_url, presence: true


end
