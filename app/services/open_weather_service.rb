require 'http'

class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def initialize(city_name)
    @city_name = city_name
    @api_key = ENV['api_key']
  end

  def fetch_weather
    response = HTTP.get("#{BASE_URL}?q=#{@city_name}&appid=#{@api_key}&units=metric")

    if response.status.success?
      JSON.parse(response.to_s)
    else
      nil
    end
  end
end
