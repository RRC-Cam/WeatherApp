class City < ApplicationRecord
  has_many :weathers

  def update_weather
    service = OpenWeatherService.new(self.name)
    data = service.fetch_weather

    if data
      # Extract weather information
      temp = data['main']['temp']
      description = data['weather'][0]['description']

      # Create a new weather entry for this city
      self.weathers.create(
        temperature: temp,
        weather_description: description
      )
    else
      puts "Failed to fetch weather data for #{self.name}"
    end
  end
end
