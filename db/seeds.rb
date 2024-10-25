# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'net/http'
require 'json'

# Your OpenWeather API key
openweather_api_key = "api_key"

# Latitude and Longitude for North America (centered around central US)
lat = 39.8283   # Example latitude (central US)
lon = -98.5795  # Example longitude (central US)
batch_size = 50 # Max number of cities per API request (OpenWeather limit)
total_cities = 250 # Desired number of cities
total_fetched_cities = 0

# Clear existing data
puts "Clearing old data..."
Weather.delete_all
City.delete_all

# Function to fetch weather data for a batch of cities
def fetch_cities(openweather_api_key, lat, lon, batch_size)
  uri = URI("http://api.openweathermap.org/data/2.5/find?lat=#{lat}&lon=#{lon}&cnt=#{batch_size}&appid=#{openweather_api_key}&units=metric")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

puts "Fetching cities from OpenWeather API in batches..."

while total_fetched_cities < total_cities
  # Fetch cities for the current batch
  result = fetch_cities(openweather_api_key, lat, lon, batch_size)

  # Check for any errors or issues with the response
  if result['list'].nil?
    puts "API request failed or returned no data. Here is the full response:"
    puts result.inspect
    break
  else
    # Extract city names and weather data from the API response
    result['list'].each do |city_data|
      city_name = city_data['name']

      # Check if the city has valid weather data (e.g., 'main' and 'weather' fields must exist)
      if city_data['main'] && city_data['weather']
        # Check if the city already exists in the database
        city = City.find_or_create_by(name: city_name)

        # Check if the city already has weather data
        if city.weathers.exists?
          puts "#{city_name} already has weather data, skipping..."
        else
          # If no weather data exists, create it
          city.weathers.create!(
            temperature: city_data['main']['temp'],
            weather_description: city_data['weather'].first['description']
          )
          puts "Weather data saved for #{city_name}"
          total_fetched_cities += 1
        end
      else
        puts "No valid weather data for #{city_name}, skipping..."
      end

      # Stop if we've reached the desired number of cities
      break if total_fetched_cities >= total_cities
    end

    puts "Total cities fetched: #{total_fetched_cities}"
  end

  # Adjust latitude/longitude slightly to avoid fetching the same cities repeatedly
  lon -= 1
  lat -= 0.3
end

puts "Seeding complete!"
