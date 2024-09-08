# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

# puts "Cleaning records"
# Movie.destroy_all

# puts "Parsing..."
# url = 'https://tmdb.lewagon.com/movie/top_rated'

# response = URI.open(url).read
# movies_api = JSON.parse(response)
# movies = movies_api["results"]

# movies.each do |movie|
#   Movie.create!(
#     title: movie["title"],
#     overview: movie["overview"],
#     poster_url: "https://image.tmdb.org/t/p/w500/#{movie["poster_path"]}",
#     rating: movie["vote_average"].round(1)
#   )
# end

# puts "Seeding Finished!"

puts "Cleaning database"
Movie.destroy_all
url = URI("https://moviedatabase8.p.rapidapi.com/Random/20")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
request["x-rapidapi-host"] = 'moviedatabase8.p.rapidapi.com'

response = http.request(request)
movie_api = JSON.parse(response.read_body)
puts movie_api

Movie.create!(
  title: movie_api["title"],
  overview: movie_api["overview"],
  poster_url: movie_api["poster_path"],
  genres: movie_api["genres"],
  production_companies: movies_api["production_companies"],
  production_country: movies_api["production_countries"],
  release_date_time: movies_api["release_date"]
)

puts "Database seeded"
