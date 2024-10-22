require "http"

class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def initialize(city_name)
    @city_name = city_name
    @api_key = ENV['3448845624d0c58ac787549dffb44cb2']
  end

  def fetch_weather
    response = HTTP.get("#{BASE_URL}?q=#{@city_name}&appid=#{@api_key}&units=metric")
    JSON.parse(response.to_s) if response.status.success?
  end
end
