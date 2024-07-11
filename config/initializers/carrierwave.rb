# config/initializers/carrierwave.rb

require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.storage = :file # or :fog, :s3, etc.
  # Add any other CarrierWave configuration here
end
