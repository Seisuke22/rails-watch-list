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

# puts @cleaned_ids

# Fetch Trailer id
@cleaned_ids.each do |movie_id|
  movie_trailers_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-trailers?tconst=#{movie_id}")
  request = Net::HTTP::Get.new(movie_trailers_url)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  movie_trailer_url = JSON.parse(response.read_body)
  # puts JSON.pretty_generate(movie_trailer_url)
  @movie_trailer_url_ids = []
  @movie_trailer_url_ids << movie_trailer_url['data']['title']['primaryVideos']['edges'][0]['node']['id']
  # puts @movie_trailer_url_ids.inspect
end


# Fetch Video using Trailer id
@movie_trailer_url_ids.each do |movie_ids|
  play_back_movies = URI("https://imdb8.p.rapidapi.com/title/v2/get-video-playback?viconst=#{movie_ids}")
  request = Net::HTTP::Get.new(play_back_movies)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  # puts response.nil?
  playback_videos_url = JSON.parse(response.read_body)
  # puts JSON.pretty_generate(playback_videos_url)
  @playback_video_url = playback_videos_url['data']['video']['playbackURLs'][1]['url']
  # puts @playback_video_url.inspect
end

# Fetch 5 Extra Images for Movie
@cleaned_ids.each do |movie_ids|
  movie_image = URI("https://imdb8.p.rapidapi.com/title/v2/get-images?tconst=#{movie_ids}&first=5")
  request = Net::HTTP::Get.new(movie_image)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  movie_image_json = JSON.parse(response.read_body)
  # puts JSON.pretty_generate(movie_image_url)
  image_nodes = movie_image_json['data']['title']['images']['edges']

  @array_of_images_urls = []

  image_nodes.each do |image_urls|
    @array_of_images_urls << image_urls['node']['url']
  end

  # puts @array_of_images_urls.inspect
end

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
    title: movie_overviews['data']['title']['titleText'],
    overview: movie_overviews['data']['title']['plot']['plotText']['plainText'],
    poster_url: movie_overviews['data']['title']['primaryImage']['url'],
    rating: movie_overviews['data']['title']['metacritic']['metascore']['score'],
    release_date_time: movie_overviews['data']['title']['releaseYear']['year'],
    runtime: movie_overviews['data']['title']['runtime']['seconds'],
    trailer_url: @playback_video_url,
    images_url: @array_of_images_urls.each { |image_url_link| puts image_url_link}
  )
end
