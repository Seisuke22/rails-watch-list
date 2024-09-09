class Movie < ApplicationRecord
  has_many :bookmarks

  serialize :images_url, Array

  validates :title, uniqueness: true
  validates :release_date_time, :overview, presence: true
  validates :overview, :overview, presence: true
  validates :poster_url, :overview, presence: true
  validates :runtime, :overview, presence: true
  validates :trailer_url, :overview, presence: true
  validates :images_url, :overview, presence: true

end
