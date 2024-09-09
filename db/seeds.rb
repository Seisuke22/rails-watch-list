require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

# Cleans database
puts "Cleaning Database"
Movie.destroy_all

# Fetch 5 popular movie ids
popular_movies_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-popular-movies-by-genre?genre=adventure&limit=1")

http = Net::HTTP.new(popular_movies_url.host, popular_movies_url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(popular_movies_url)
request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

response = http.request(request)
popular_movie_ids = JSON.parse(response.read_body)
puts JSON.pretty_generate(popular_movie_ids)

@cleaned_ids = popular_movie_ids.map do |id|
  id.gsub('/title/', '').gsub('/', '')
end

puts @cleaned_ids

# Fetch the overviews of each movies
puts "Overview Movie JSON"
@cleaned_ids.each do |movie_id|
  overview_details_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-overview?tconst=#{movie_id}&country=US&language=en-US")
  request = Net::HTTP::Get.new(overview_details_url)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  movie_overviews = JSON.parse(response.read_body)
  puts JSON.pretty_generate(movie_overviews)

  Movie.create!(
    title: movie_overviews["data"]["title"]["titleText"],
    overview: movie_overviews["data"]["title"]["plot"]["plotText"]["plainText"],
    poster_url: movie_overviews["data"]["title"]["primaryImage"]["url"]
    rating: movie_overviews["data"]["title"]["metacritic"]["metascore"]["score"]

  )
end
