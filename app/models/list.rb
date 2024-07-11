class List < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks

  validates :name, presence: true
  validates :name, uniqueness: true

end
