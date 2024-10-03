# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :bookmarks
  has_many :lists, through: :bookmark
  belongs_to :user

  validates :title, uniqueness: true
  validates :title, :actor_name, :actor_image, :release_year, :overview, :poster_url, :trailer_url, presence: true
end
