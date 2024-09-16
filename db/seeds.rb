require 'open-uri'
require 'json'
require 'uri'
require 'net/http'

# Cleans database
puts 'Seeding started ...'
puts "Cleaning Database ..."
Movie.destroy_all

puts "Fetching 10 popular movie ids..."
# Fetch 5 popular movie ids
popular_movies_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-popular-movies-by-genre?genre=adventure&limit=10")

http = Net::HTTP.new(popular_movies_url.host, popular_movies_url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(popular_movies_url)
request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

response = http.request(request)
popular_movie_ids = JSON.parse(response.read_body)
# puts JSON.pretty_generate(popular_movie_ids)

@cleaned_ids = popular_movie_ids.map do |id|
  id.gsub('/title/', '').gsub('/', '')
end
puts "All Fetched movie ids:"
puts @cleaned_ids.inspect
puts "Finished!"


puts "Fetching trailer ids for every movies..."
# Fetch Trailer id
@cleaned_ids.each do |movie_id|
  movie_trailers_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-trailers?tconst=#{movie_id}")
  request = Net::HTTP::Get.new(movie_trailers_url)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  movie_trailer_url = JSON.parse(response.read_body)
  # puts JSON.pretty_generate(movie_trailer_url)
  empty_url_id_check = movie_trailer_url['data']['title']['primaryVideos']['edges']
  if empty_url_id_check.empty?
    puts 'No Available Trailer for' + " " + "#{movie_id}"
  else
    @movie_trailer_url_ids = []
    @movie_trailer_url_ids << movie_trailer_url['data']['title']['primaryVideos']['edges'][0]['node']['id']
  end
  puts @movie_trailer_url_ids.inspect
end
puts 'All Fetched Movie Trailer ids'
puts "finished!"

puts "fetcing trailer videos..."
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
puts "finished!"

puts 'fetching Movie actors with images... '
# Fetch Movie Actors with image
@cleaned_ids.each do |movie_id|
  movie_actors = URI("https://imdb8.p.rapidapi.com/title/v2/get-full-cast-and-crew?tconst=#{movie_id}&first=5&country=US&language=en-US")
  request = Net::HTTP::Get.new(movie_actors)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  respone = http.request(request)
  movie_actor = JSON.parse(respone.read_body)

  actors = movie_actor.dig('data', 'title', 'credits', 'edges')

  # fetcing names
  @names = actors.each do |name|
    name.dig('node', 'name', 'nameText')
  end

  @images = actors.each do |image|
    image.dig('node', 'name', 'primaryImage', 'url')
  end
end
puts 'finished!'

# Fetch the overviews of each movies
puts 'fetching overview for each movies...'
puts 'creating movies...'
@cleaned_ids.each do |movie_id|
  overview_details_url = URI("https://imdb8.p.rapidapi.com/title/v2/get-overview?tconst=#{movie_id}&country=US&language=en-US")
  request = Net::HTTP::Get.new(overview_details_url)
  request["x-rapidapi-key"] = 'a3253ec5e2msh1b3a64110b486e2p18c5f7jsne048d510e7d7'
  request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

  response = http.request(request)
  movie_overviews = JSON.parse(response.read_body)
  # puts JSON.pretty_generate(movie_overviews)
  # puts movie_overviews['data']['title']['releaseYear']['year']
  movie_title = movie_overviews.dig('data', 'title', 'titleText', 'text')
  movie_overview = movie_overviews.dig('data', 'title', 'plot', 'plotText', 'plainText')
  movie_poster_url = movie_overviews.dig('data', 'title', 'primaryImage', 'url')
  movie_release_year = movie_overviews.dig('data', 'title', 'releaseYear', 'year')
  movie_runtime = movie_overviews.dig('data', 'title', 'runtime', 'seconds')
  movie_rating = movie_overviews.dig('data', 'title', 'metacritic', 'metascore', 'score')

  # Check if there's no metascore on a movie
  # no_rating_check = movie_overviews['data']['title']['metacritic']['metascore']
  if movie_rating.nil?
    puts "No Rating for #{movie_id}"
  end
  Movie.create!(
    title: movie_title,
    overview: movie_overview,
    poster_url: movie_poster_url,
    rating: movie_rating,
    release_year: movie_release_year,
    runtime: movie_runtime,
    trailer_url: @playback_video_url,
    images_url: @array_of_images_urls,
    actor_name: @names,
    actor_image: @images
  )
end
puts 'finished!'
puts 'Seeding Completed!'
