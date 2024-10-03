# frozen_string_literal: true

require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

# Cleans database
puts 'Seeding started ...'
puts 'Cleaning Database ...'
Movie.destroy_all

puts 'Fetching 10 popular movie ids...'
# Fetch 2 popular movie ids
popular_movies_url = URI('https://imdb8.p.rapidapi.com/title/v2/get-popular-movies-by-genre?genre=adventure&limit=10')

http = Net::HTTP.new(popular_movies_url.host, popular_movies_url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(popular_movies_url)
request_headers(request)

response = http.request(request)
popular_movie_ids = JSON.parse(response.read_body)

@cleaned_ids = popular_movie_ids.map do |id|
  id.gsub('/title/', '').gsub('/', '')
end
puts 'All Fetched movie ids:'
puts @cleaned_ids.inspect
puts 'Finished!'

def http_client
  http = Net::HTTP.new('imdb8.p.rapidapi.com', 443)
  http.use_ssl = true
  http
end

def request_headers(request)
  request['x-rapidapi-key'] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request['x-rapidapi-host'] = 'imdb8.p.rapidapi.com'
end

def fetch_trailer(movie_id)
  movie_trailers_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-trailers?tconst=#{movie_id}")
  request = Net::HTTP::Get.new(movie_trailers_url)
  request_headers(request)

  response = http_client.request(request)
  movie_trailer_url = JSON.parse(response.read_body)

  trailer_data = movie_trailer_url.dig('data', 'title', 'primaryVideos', 'edges')
  return nil if trailer_data.nil? || trailer_data.empty?

  trailer_data[0].dig('node', 'id')
end

def fetch_video_url(trailer_id)
  play_back_movies = URI("https://imdb8.p.rapidapi.com/title/v2/get-video-playback?viconst=#{trailer_id}")
  request = Net::HTTP::Get.new(play_back_movies)
  request_headers(request)

  response = http_client.request(request)
  playback_videos_url = JSON.parse(response.read_body)
  playback_videos_url.dig('data', 'video', 'playbackURLs', 1, 'url')
end

def fetch_actors(movie_id)
  movie_actors = URI("https://imdb8.p.rapidapi.com/title/v2/get-full-cast-and-crew?tconst=#{movie_id}&first=5&country=US&language=en-US")
  request = Net::HTTP::Get.new(movie_actors)
  request_headers(request)

  response = http_client.request(request)
  movie_actor = JSON.parse(response.read_body)
  actors = movie_actor.dig('data', 'title', 'credits', 'edges')

  {
    names: actors.map { |actor| actor.dig('node', 'name', 'nameText', 'text') },
    images: actors.map { |actor| actor.dig('node', 'name', 'primaryImage', 'url') }
  }
end

def movie_details_fetch(movie_overviews)
  {
    title: movie_overviews.dig('data', 'title', 'titleText', 'text'),
    overview: movie_overviews.dig('data', 'title', 'plot', 'plotText', 'plainText'),
    poster_url: movie_overviews.dig('data', 'title', 'primaryImage', 'url'),
    release_year: movie_overviews.dig('data', 'title', 'releaseYear', 'year'),
    runtime: movie_overviews.dig('data', 'title', 'runtime', 'seconds'),
    rating: movie_overviews.dig('data', 'title', 'metacritic', 'metascore', 'score')
  }
end

def fetch_movie_overview(movie_id)
  overview_details_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-overview?tconst=#{movie_id}&country=US&language=en-US")
  request = Net::HTTP::Get.new(overview_details_url)
  request_headers(request)

  response = http_client.request(request)
  movie_overviews = JSON.parse(response.read_body)
  movie_details_fetch(movie_overviews)
end


end

# Main loop
puts 'Fetching Trailers, Actors and creating Movies...'
@cleaned_ids.each do |movie_id|
  trailer_id = fetch_trailer(movie_id)
  next unless trailer_id

  playback_video_url = fetch_video_url(trailer_id)
  actors_data = fetch_actors(movie_id)
  movie_details = fetch_movie_overview(movie_id)

  Movie.create!(
    title: movie_details[:title],
    overview: movie_details[:overview],
    poster_url: movie_details[:poster_url],
    rating: movie_details[:rating],
    release_year: movie_details[:release_year],
    runtime: movie_details[:runtime],
    trailer_url: playback_video_url,
    actor_name: actors_data[:names],
    actor_image: actors_data[:images]
  )
end
puts 'Seeding Finished!'
